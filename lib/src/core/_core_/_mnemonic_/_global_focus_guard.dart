part of '../core.dart';

/// Global pointer, keyboard, and post-execution focus coordinator that:
/// 1. Preserves active region focus when clicking non-focusable regions (e.g.,
///    [BlockItemsView] with [ViewMouseFocusPolicy.strictNavigationOnly]), even
///    across asynchronous [ExecutionUnit] batches that display a full-screen
///    loading overlay.
/// 2. Transfers focus to an explicit target [ActiveFocusRegion] requested by an
///    [ExecutionUnit] (e.g., moving focus into [BlockFormView] after preparing
///    a form for creation or editing), superseding passive focus restoration.
/// 3. Listens for [MnemonicShortcut.locateRegion] globally to trigger a visual
///    focus indicator pulse on the currently active [_FocusableViewRegionState].
class _GlobalFocusGuard {
  static bool _installed = false;

  static _FocusableViewRegionState? _lastValidRegion;
  static FocusNode? _lastLeafFocusNode;
  static int? _lastLeafOrdinalIndex;

  // Priority 1: Explicit target region requested by an ExecutionUnit.
  static ActiveFocusRegion? _pendingExplicitFocusRegion;

  // Priority 2: Passive fallback region captured before a pointer-triggered batch.
  static _FocusableViewRegionState? _pendingRegionAfterExecution;
  static FocusNode? _pendingLeafNodeAfterExecution;
  static int? _pendingLeafIndexAfterExecution;

  static bool _pointerDownCaptured = false;

  /// Installs the global pointer route and hardware keyboard handlers once.
  static void ensureInstalled() {
    if (_installed) return;
    _installed = true;
    GestureBinding.instance.pointerRouter.addGlobalRoute(_handlePointerEvent);
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  // ***************************************************************************

  /// Requests that keyboard focus be transferred to [targetRegion] once the
  /// current execution batch finishes, the loading overlay is dismissed, and
  /// target views have rebuilt.
  ///
  /// Takes highest priority and clears any pending passive focus restoration
  /// captured from a preceding pointer event. If the executor is currently idle,
  /// schedules the focus transfer on the next post-frame callback.
  static void requestFocusAfterExecution(ActiveFocusRegion targetRegion) {
    _pendingExplicitFocusRegion = targetRegion;
    _clearPassiveRestoreTarget();

    if (!FlutterArtist.executor.isBusy &&
        FlutterArtist.executor.executingXModuleId == null) {
      onExecutionQueueCompleted();
    }
  }

  // ***************************************************************************

  static void _clearPassiveRestoreTarget() {
    _pendingRegionAfterExecution = null;
    _pendingLeafNodeAfterExecution = null;
    _pendingLeafIndexAfterExecution = null;
  }

  // ***************************************************************************

  /// Intercepts global keyboard shortcuts managed at the focus-guard level,
  /// such as [MnemonicShortcut.locateRegion] (`Ctrl/Alt + L`).
  static bool _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    if (MnemonicShortcut.locateRegion.matches(
      event,
      HardwareKeyboard.instance,
    )) {
      final _FocusableViewRegionState? activeRegion =
          _RegionDispatcher.currentlyFocusedRegion;
      if (activeRegion != null && activeRegion.mounted) {
        activeRegion.flashFocusIndicator();
        return true;
      }
    }

    return false;
  }

  // ***************************************************************************

  static void _handlePointerEvent(PointerEvent event) {
    if (event is PointerDownEvent) {
      final _FocusableViewRegionState? activeRegion =
          _RegionDispatcher.currentlyFocusedRegion;
      final FocusNode? primary = FocusManager.instance.primaryFocus;

      if (activeRegion != null) {
        _lastValidRegion = activeRegion;
        _lastLeafFocusNode =
        (primary != null && primary != activeRegion.focusNode)
            ? primary
            : null;
        _lastLeafOrdinalIndex = _resolveOrdinalIndex(
          focusableRegionState: activeRegion,
          targetFocusNode: primary,
        );
        _pointerDownCaptured = true;
      } else {
        _pointerDownCaptured = false;
      }
    } else if (event is PointerUpEvent && _pointerDownCaptured) {
      _pointerDownCaptured = false;
      final _FocusableViewRegionState? region = _lastValidRegion;
      final FocusNode? leaf = _lastLeafFocusNode;
      final int? index = _lastLeafOrdinalIndex;

      _lastValidRegion = null;
      _lastLeafFocusNode = null;
      _lastLeafOrdinalIndex = null;

      if (region == null) return;

      SchedulerBinding.instance.addPostFrameCallback((_) {
        // If an execution batch (and its full-screen overlay) started as a result
        // of this click (e.g., selecting an item in BlockItemsView), defer focus
        // restoration until the executor finishes and dismisses the overlay.
        if (FlutterArtist.executor.isBusy ||
            FlutterArtist.executor.executingXModuleId != null) {
          // Do not overwrite if an explicit target region was already requested.
          if (_pendingExplicitFocusRegion == null) {
            _pendingRegionAfterExecution = region;
            _pendingLeafNodeAfterExecution = leaf;
            _pendingLeafIndexAfterExecution = index;
          }
          return;
        }

        _tryRestoreFocus(
          candidateRegionState: region,
          candidateLeaf: leaf,
          candidateIndex: index,
        );
      });
    } else if (event is PointerCancelEvent) {
      _pointerDownCaptured = false;
      _lastValidRegion = null;
      _lastLeafFocusNode = null;
      _lastLeafOrdinalIndex = null;
    }
  }

  // ***************************************************************************

  /// Invoked by [_Executor] once all queued execution units have finished,
  /// views have been refreshed, and the blocking overlay has been removed.
  static void onExecutionQueueCompleted() {
    final ActiveFocusRegion? explicitRegion = _pendingExplicitFocusRegion;
    final _FocusableViewRegionState? passiveRegion =
        _pendingRegionAfterExecution;
    final FocusNode? passiveLeaf = _pendingLeafNodeAfterExecution;
    final int? passiveIndex = _pendingLeafIndexAfterExecution;

    _pendingExplicitFocusRegion = null;
    _clearPassiveRestoreTarget();

    if (explicitRegion == null && passiveRegion == null) return;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      // Priority 1: Explicit focus transfer requested by an ExecutionUnit.
      if (explicitRegion != null) {
        final _FocusableViewRegionState? targetState =
        _RegionDispatcher.findEligibleRegion(explicitRegion);
        if (targetState != null) {
          targetState.requestRegionFocus();
        }
        return;
      }

      // Priority 2: Passive focus preservation after pointer-driven rebuild.
      if (passiveRegion != null) {
        _tryRestoreFocus(
          candidateRegionState: passiveRegion,
          candidateLeaf: passiveLeaf,
          candidateIndex: passiveIndex,
        );
      }
    });
  }

  // ***************************************************************************

  static int? _resolveOrdinalIndex({
    required _FocusableViewRegionState focusableRegionState,
    required FocusNode? targetFocusNode,
  }) {
    if (targetFocusNode == null ||
        targetFocusNode == focusableRegionState.focusNode) {
      return null;
    }
    final List<FocusNode> nodes =
    focusableRegionState.getStableDescendantNodes();
    final int idx = nodes.indexOf(targetFocusNode);
    return idx >= 0 ? idx : null;
  }

  // ***************************************************************************

  static void _tryRestoreFocus({
    required _FocusableViewRegionState candidateRegionState,
    required FocusNode? candidateLeaf,
    required int? candidateIndex,
  }) {
    // 1. Do not interfere if primaryFocus is currently held by an actual leaf widget
    //    (e.g., another TextField or a clickToFocus region).
    //    When focus drops due to unfocusing or widget rebuilds, Flutter sets
    //    primaryFocus to the enclosing ModalRoute's FocusScopeNode (or null).
    final FocusNode? currentPrimary = FocusManager.instance.primaryFocus;
    if (currentPrimary != null && currentPrimary is! FocusScopeNode) {
      return;
    }

    // 2. Abort if the region wrapper is no longer mounted or enabled.
    if (!candidateRegionState.mounted || !candidateRegionState.widget.enabled) {
      return;
    }

    final BuildContext ctx = candidateRegionState.context;

    // 3. Route isolation: Abort if the region's route is no longer the
    //    top-most active route (works for both page navigation and Dialogs).
    final ModalRoute<dynamic>? route = ModalRoute.of(ctx);
    if (route != null && !route.isCurrent) {
      return;
    }

    // 4. Drawer / EndDrawer isolation: If a Drawer/EndDrawer is open, only
    //    restore focus if the region resides inside that Drawer.
    final bool isDrawerOpen = FlutterArtist.backstage.drawer.isOpen ||
        FlutterArtist.backstage.endDrawer.isOpen;
    if (isDrawerOpen &&
        ctx.findAncestorStateOfType<DrawerControllerState>() == null) {
      return;
    }

    // Tier 1: Restore the exact FocusNode if it survived the rebuild and is still enabled.
    if (candidateLeaf != null &&
        candidateLeaf.context != null &&
        candidateLeaf.context!.mounted &&
        candidateLeaf.canRequestFocus) {
      candidateLeaf.requestFocus();
      return;
    }

    // Tier 2: Restore by stable ordinal index with nearest-enabled-neighbor & read-only fallback.
    if (candidateIndex != null) {
      candidateRegionState.restoreFocusAtIndex(candidateIndex);
      return;
    }

    // Tier 3: Initial entry fallback (first enabled field or outer region wrapper).
    candidateRegionState.requestRegionFocus();
  }
}