part of '../../core.dart';

/// Global pointer and execution guard that preserves active region focus when
/// clicking non-focusable regions (e.g., [BlockItemsView] with
/// [ViewMouseFocusPolicy.strictNavigationOnly]), even across asynchronous
/// [ExecutionUnit] batches that display a full-screen loading overlay.
class _GlobalFocusGuard {
  static bool _installed = false;

  static _FocusableViewRegionState? _lastValidRegion;
  static FocusNode? _lastLeafFocusNode;
  static int? _lastLeafOrdinalIndex;

  static _FocusableViewRegionState? _pendingRegionAfterExecution;
  static FocusNode? _pendingLeafNodeAfterExecution;
  static int? _pendingLeafIndexAfterExecution;

  static bool _pointerDownCaptured = false;

  /// Installs the global pointer route handler once.
  static void ensureInstalled() {
    if (_installed) return;
    _installed = true;
    GestureBinding.instance.pointerRouter.addGlobalRoute(_handlePointerEvent);
  }

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
        _lastLeafOrdinalIndex = _resolveOrdinalIndex(activeRegion, primary);
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
          _pendingRegionAfterExecution = region;
          _pendingLeafNodeAfterExecution = leaf;
          _pendingLeafIndexAfterExecution = index;
          return;
        }

        _tryRestoreFocus(region, leaf, index);
      });
    } else if (event is PointerCancelEvent) {
      _pointerDownCaptured = false;
      _lastValidRegion = null;
      _lastLeafFocusNode = null;
      _lastLeafOrdinalIndex = null;
    }
  }

  /// Invoked by [_Executor] once all queued execution units have finished,
  /// views have been refreshed, and the blocking overlay has been removed.
  static void onExecutionQueueCompleted() {
    final _FocusableViewRegionState? region = _pendingRegionAfterExecution;
    final FocusNode? leaf = _pendingLeafNodeAfterExecution;
    final int? index = _pendingLeafIndexAfterExecution;

    _pendingRegionAfterExecution = null;
    _pendingLeafNodeAfterExecution = null;
    _pendingLeafIndexAfterExecution = null;

    if (region == null) return;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _tryRestoreFocus(region, leaf, index);
    });
  }

  static int? _resolveOrdinalIndex(
    _FocusableViewRegionState region,
    FocusNode? target,
  ) {
    if (target == null || target == region.focusNode) return null;
    final List<FocusNode> nodes = region.getStableDescendantNodes();
    final int idx = nodes.indexOf(target);
    return idx >= 0 ? idx : null;
  }

  static void _tryRestoreFocus(
    _FocusableViewRegionState candidateRegion,
    FocusNode? candidateLeaf,
    int? candidateIndex,
  ) {
    // 1. Do not interfere if primaryFocus is currently held by an actual leaf widget
    //    (e.g., another TextField or a clickToFocus region).
    //    When focus drops due to unfocusing or widget rebuilds, Flutter sets
    //    primaryFocus to the enclosing ModalRoute's FocusScopeNode (or null).
    final FocusNode? currentPrimary = FocusManager.instance.primaryFocus;
    if (currentPrimary != null && currentPrimary is! FocusScopeNode) {
      return;
    }

    // 2. Abort if the region wrapper is no longer mounted or enabled.
    if (!candidateRegion.mounted || !candidateRegion.widget.enabled) {
      return;
    }

    final BuildContext ctx = candidateRegion.context;

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
      candidateRegion.restoreFocusAtIndex(candidateIndex);
      return;
    }

    // Tier 3: Initial entry fallback (first enabled field or outer region wrapper).
    candidateRegion.requestRegionFocus();
  }
}
