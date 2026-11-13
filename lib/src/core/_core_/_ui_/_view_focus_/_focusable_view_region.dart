part of '../../core.dart';

/// Reusable wrapper widget that turns any ViewBuilder into a keyboard-focusable
/// region with configurable mouse-focus acquisition and visual [ViewFocusStyle] rendering.
class _FocusableViewRegion extends StatefulWidget {
  final String debugLabel;
  final bool enabled;
  final ViewMouseFocusPolicy mouseFocusPolicy;
  final FocusOnKeyEventCallback? onKeyEvent;
  final Widget child;

  const _FocusableViewRegion({
    super.key,
    required this.debugLabel,
    this.enabled = true,
    this.mouseFocusPolicy = ViewMouseFocusPolicy.clickToFocus,
    this.onKeyEvent,
    required this.child,
  });

  @override
  State<_FocusableViewRegion> createState() => _FocusableViewRegionState();
}

class _FocusableViewRegionState extends State<_FocusableViewRegion> {
  late final FocusNode _focusNode;
  bool _hasFocus = false;

  /// Exposes the internal [FocusNode] for programmatic region switching (e.g., `Ctrl + Tab`).
  FocusNode get focusNode => _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(debugLabel: widget.debugLabel);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange(bool hasFocus) {
    if (_hasFocus != hasFocus && mounted) {
      setState(() {
        _hasFocus = hasFocus;
      });
    }
  }

  /// Requests focus on [PointerUpEvent] rather than [PointerDownEvent] so that
  /// child gesture recognizers (such as `ListTile.onTap`) can complete their
  /// Down -> Up tap sequence without being interrupted by focus-loss rebuilds.
  void _onPointerUp(PointerUpEvent event) {
    if (!widget.enabled) return;
    if (widget.mouseFocusPolicy != ViewMouseFocusPolicy.clickToFocus) return;

    if (!_focusNode.hasPrimaryFocus) {
      _focusNode.requestFocus();
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
        canRequestFocus: true,
        // Prevent internal ListTiles/InkWells from claiming individual focus nodes
        // or intercepting TAB traversal, while keeping their GestureDetector (onTap) 100% active.
        descendantsAreFocusable: false,
        descendantsAreTraversable: false,
        onFocusChange: _onFocusChange,
        onKeyEvent: widget.onKeyEvent,
        child: widget.child,
      ),
    );
  }
}