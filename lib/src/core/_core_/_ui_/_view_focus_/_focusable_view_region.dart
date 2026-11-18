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
  final FocusIndicatorConfig indicatorConfig;
  final Widget child;

  const _FocusableViewRegion({
    super.key,
    required this.debugLabel,
    this.enabled = true,
    this.allowDescendantFocus = false,
    this.mouseFocusPolicy = ViewMouseFocusPolicy.strictNavigationOnly,
    this.onKeyEvent,
    required this.regionInfo,
    this.indicatorConfig = const FocusIndicatorConfig(),
    required this.child,
  });

  @override
  State<_FocusableViewRegion> createState() => _FocusableViewRegionState();
}

class _FocusableViewRegionState extends State<_FocusableViewRegion>
    with SingleTickerProviderStateMixin {
  late final FocusNode _focusNode;
  bool _hasFocus = false;

  late final AnimationController _indicatorController;
  late final Animation<double> _indicatorOpacity;

  bool _activePulseShowDot = false;
  bool _activePulseShowOverlay = false;

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
    _indicatorController = AnimationController(
      vsync: this,
      duration: widget.indicatorConfig.duration,
    );

    // Hold full visibility briefly (25%), then fade out smoothly (75%).
    _indicatorOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0).chain(
          CurveTween(curve: Curves.easeOutCubic),
        ),
        weight: 75,
      ),
    ]).animate(_indicatorController);

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
    _indicatorController.dispose();
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
        _onRegionFocusGained();
      } else {
        FlutterArtist.focusTracker.notifyRegionUnfocused(widget.regionInfo);
      }
    }
  }

  void _onRegionFocusGained() {
    final config = widget.indicatorConfig;
    if (!config.enabled) return;

    flashFocusIndicator(
      showDot: config.flashDotOnFocus,
      showOverlay: config.flashOverlayOnFocus,
    );
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
        child: _wrapWithFocusIndicator(context, widget.child),
      ),
    );
  }

  /// Wraps [child] with non-interactive visual focus indicator layers.
  Widget _wrapWithFocusIndicator(BuildContext context, Widget child) {
    final FocusIndicatorConfig config = widget.indicatorConfig;
    if (!config.enabled) return child;

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color effectiveDotColor = config.dotColor ?? colorScheme.primary;
    final Color effectiveOverlayColor =
        config.overlayColor ?? effectiveDotColor.withValues(alpha: 0.08);
    final Color effectiveBorderColor =
        config.borderColor ?? effectiveDotColor.withValues(alpha: 0.45);

    return Stack(
      fit: StackFit.passthrough,
      children: [
        child,
        AnimatedBuilder(
          animation: _indicatorOpacity,
          builder: (context, _) {
            final double opacity = _indicatorOpacity.value;
            if (opacity <= 0.0) {
              return const SizedBox.shrink();
            }

            return Positioned.fill(
              child: IgnorePointer(
                child: Opacity(
                  opacity: opacity,
                  child: Stack(
                    children: [
                      if (_activePulseShowOverlay)
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: effectiveOverlayColor,
                              border: Border.all(
                                color: effectiveBorderColor,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(
                                config.overlayBorderRadius,
                              ),
                            ),
                          ),
                        ),
                      if (_activePulseShowDot)
                        Positioned(
                          top: config.dotTopOffset,
                          right: config.dotRightOffset,
                          child: Container(
                            width: config.dotSize,
                            height: config.dotSize,
                            decoration: BoxDecoration(
                              color: effectiveDotColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: effectiveDotColor.withValues(
                                    alpha: 0.45,
                                  ),
                                  blurRadius: 4,
                                  spreadRadius: 0.5,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
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
    //    outer region node so status bar context and mnemonic shortcuts stay active.
    _focusNode.requestFocus();
  }

  /// Triggers a transient visual pulse on this region's indicator dot and/or
  /// full-region tint overlay.
  ///
  /// When [showDot] or [showOverlay] are omitted, defaults to the explicit
  /// locate settings ([FocusIndicatorConfig.flashDotOnLocate] and
  /// [FocusIndicatorConfig.flashOverlayOnLocate]).
  void flashFocusIndicator({
    bool? showDot,
    bool? showOverlay,
  }) {
    final FocusIndicatorConfig config = widget.indicatorConfig;
    if (!config.enabled || !mounted) return;

    final bool resolvedDot = showDot ?? config.flashDotOnLocate;
    final bool resolvedOverlay = showOverlay ?? config.flashOverlayOnLocate;

    if (!resolvedDot && !resolvedOverlay) return;

    _activePulseShowDot = resolvedDot;
    _activePulseShowOverlay = resolvedOverlay;
    _indicatorController.duration = config.duration;
    _indicatorController.forward(from: 0.0);
  }
}
