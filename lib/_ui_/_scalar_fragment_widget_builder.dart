part of '../flutter_artist.dart';

class ScalarFragmentWidgetBuilder extends _StatefulWidget {
  final Scalar scalar;
  final Widget Function(Scalar blk) build;

  const ScalarFragmentWidgetBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.scalar,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _ScalarFragmentWidgetBuilderState();
  }
}

class _ScalarFragmentWidgetBuilderState
    extends _WidgetState<ScalarFragmentWidgetBuilder> {
  late final String keyId;

  @override
  String get locationInfo => getClassName(widget.ownerClassInstance);

  @override
  String get description {
    return widget.description == null || widget.description!.trim().isEmpty
        ? "${getClassName(widget.scalar)} (Scalar Fragment)"
        : widget.description!;
  }

  @override
  WidgetStateType get type => WidgetStateType.scalarFragment;

  @override
  void refreshState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //
    keyId = _generateVisibilityDetectorId(prefix: getClassName(widget.scalar));
    //
    _addWidgetStateListener(isShowing: true);
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(keyId),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        _addWidgetStateListener(isShowing: visiblePercentage > 0);
      },
      child: showMode == ShowMode.production
          ? widget.build(widget.scalar)
          : _DevContainer(
              child: widget.build(widget.scalar),
            ),
    );
  }

  void _addWidgetStateListener({required bool isShowing}) {
    widget.scalar._addWidgetStateListener(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.scalar._removeWidgetStateListener(widgetState: this);
  }
}
