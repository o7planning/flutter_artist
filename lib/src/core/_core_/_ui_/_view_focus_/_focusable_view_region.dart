part of '../../core.dart';

/// Reusable wrapper widget that turns any [_ContextProviderView] into a
/// tracked keyboard-focusable region participating in [RegionTraversalUtils]
/// and broadcasting its identity to [FlutterArtist.focusTracker].
class _FocusableViewRegion extends StatefulWidget {
  final String debugLabel;
  final bool enabled;

  /// When `true` (e.g., inside Forms or FilterPanels), descendant input fields
  /// can claim primary focus while this outer region tracks subtree focus.
  /// When `false` (e.g., inside list/grid views), this region claims focus directly.
  final bool allowDescendantFocus;

  final ViewMouseFocusPolicy mouseFocusPolicy;
  final FocusOnKeyEventCallback? onKeyEvent;
  final ActiveFocusRegion regionInfo;
  final Widget child;

  const _FocusableViewRegion({
    super.key,
    required this.debugLabel,
    this.enabled = true,
    this.allowDescendantFocus = false,
    this.mouseFocusPolicy = ViewMouseFocusPolicy.strictNavigationOnly,
    this.onKeyEvent,
    required this.regionInfo,
    required this.child,
  });

  @override
  State<_FocusableViewRegion> createState() => _FocusableViewRegionState();
}

class _FocusableViewRegionState extends State<_FocusableViewRegion> {
  late final FocusNode _focusNode;
  bool _hasFocus = false;

  /// Exposes the internal [FocusNode] for programmatic region switching.
  FocusNode get focusNode => _focusNode;

  /// Whether this region (or any input descendant inside it) currently holds focus.
  bool get hasRegionFocus => _focusNode.hasFocus || _focusNode.hasPrimaryFocus;

  /// Evaluates whether this region belongs to the active top-most interaction layer
  /// (either the top-most Page/Dialog route, or the open Drawer/EndDrawer scope).
  bool get isEligibleForTraversal {
    if (!mounted || !widget.enabled) return false;

    // 1. Route isolation: Isolates Dialogs/Popups from underlying routes.
    final ModalRoute<dynamic>? route = ModalRoute.of(context);
    if (route != null && !route.isCurrent) {
      return false;
    }

    // 2. Drawer / EndDrawer isolation: Isolates open Drawers from the obscured page.
    final bool isDrawerOpen = FlutterArtist.backstage.drawer.isOpen ||
        FlutterArtist.backstage.endDrawer.isOpen;
    if (isDrawerOpen &&
        context.findAncestorStateOfType<DrawerControllerState>() == null) {
      return false;
    }

    // 3. Physical layout bounds check.
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject is RenderBox) {
      if (!renderObject.hasSize || renderObject.size.isEmpty) {
        return false;
      }
    }
    return true;
  }

  /// Programmatically transfers keyboard focus into this region.
  void requestRegionFocus() {
    if (!mounted || !widget.enabled) return;

    if (!widget.allowDescendantFocus) {
      _focusNode.requestFocus();
      return;
    }

    // Attempt to find the first explicitly focusable input field inside the region.
    FocusNode? targetField;
    for (final node in _focusNode.traversalDescendants) {
      if (node.canRequestFocus && !node.skipTraversal) {
        targetField = node;
        break;
      }
    }

    if (targetField != null) {
      targetField.requestFocus();
    } else {
      // CRITICAL FIX: If the form is in read-only mode (all inner fields disabled),
      // `targetField` will be null. We MUST forcefully focus the region wrapper
      // itself so the user can still traverse to it and see the status bar update!
      _focusNode.requestFocus();
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(debugLabel: widget.debugLabel);
    if (widget.enabled) {
      _RegionDispatcher.register(this);
      RegionTraversalUtils.ensureGlobalHandlerInstalled();
      _GlobalFocusGuard.ensureInstalled();
    }
  }

  @override
  void didUpdateWidget(covariant _FocusableViewRegion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) {
      if (widget.enabled) {
        _RegionDispatcher.register(this);
        RegionTraversalUtils.ensureGlobalHandlerInstalled();
        _GlobalFocusGuard.ensureInstalled();
      } else {
        _RegionDispatcher.unregister(this);
        FlutterArtist.focusTracker.notifyRegionUnfocused(widget.regionInfo);
      }
    }
  }

  @override
  void dispose() {
    _RegionDispatcher.unregister(this);
    FlutterArtist.focusTracker.notifyRegionUnfocused(widget.regionInfo);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange(bool hasFocus) {
    if (_hasFocus != hasFocus && mounted) {
      _hasFocus = hasFocus;
      if (hasFocus) {
        FlutterArtist.focusTracker.notifyRegionFocused(widget.regionInfo);
      } else {
        FlutterArtist.focusTracker.notifyRegionUnfocused(widget.regionInfo);
      }
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    if (!widget.enabled) return;
    if (widget.mouseFocusPolicy != ViewMouseFocusPolicy.clickToFocus) return;

    if (!hasRegionFocus) {
      requestRegionFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerUp: _onPointerUp,
      child: Focus(
        focusNode: _focusNode,
        // FIX THIS: `canRequestFocus: true`
        // so that the wrapper container can capture focus when the Form is locked!
        canRequestFocus: true,
        skipTraversal: widget.allowDescendantFocus,
        descendantsAreFocusable: widget.allowDescendantFocus,
        descendantsAreTraversable: widget.allowDescendantFocus,
        onFocusChange: _onFocusChange,
        onKeyEvent: widget.onKeyEvent,
        child: widget.child,
      ),
    );
  }

  /// Collects all descendant interactive nodes in reading order, including
  /// temporarily disabled fields, so positional indices remain stable across
  /// record changes even when business rules toggle individual fields.
  List<FocusNode> getStableDescendantNodes() {
    final FocusTraversalPolicy policy =
        FocusTraversalGroup.maybeOf(context) ?? ReadingOrderTraversalPolicy();

    // Filter out internal structural scope nodes while keeping actual field nodes
    final Iterable<FocusNode> rawNodes = _focusNode.descendants.where(
      (node) =>
          node != _focusNode && node is! FocusScopeNode && !node.skipTraversal,
    );

    return policy.sortDescendants(rawNodes, _focusNode).toList();
  }

  /// Restores focus by ordinal index with nearest-enabled-neighbor fallback,
  /// finally falling back to the outer region node if the entire view is read-only.
  void restoreFocusAtIndex(int targetIndex) {
    if (!mounted || !widget.enabled) return;

    if (!widget.allowDescendantFocus) {
      _focusNode.requestFocus();
      return;
    }

    final List<FocusNode> nodes = getStableDescendantNodes();
    if (nodes.isNotEmpty) {
      final int clampedIndex = targetIndex.clamp(0, nodes.length - 1);

      // 1. Exact position is enabled -> focus directly.
      if (nodes[clampedIndex].canRequestFocus) {
        nodes[clampedIndex].requestFocus();
        return;
      }

      // 2. Target field became disabled -> search forward for the nearest enabled field.
      for (int i = clampedIndex + 1; i < nodes.length; i++) {
        if (nodes[i].canRequestFocus) {
          nodes[i].requestFocus();
          return;
        }
      }

      // 3. No enabled field ahead -> search backward for the nearest enabled field.
      for (int i = clampedIndex - 1; i >= 0; i--) {
        if (nodes[i].canRequestFocus) {
          nodes[i].requestFocus();
          return;
        }
      }
    }

    // 4. Entire form/region is currently disabled (read-only mode) -> focus the
    //    outer region wrapper so status bar context and mnemonic shortcuts stay active.
    _focusNode.requestFocus();
  }
}
