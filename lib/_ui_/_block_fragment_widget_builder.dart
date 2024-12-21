part of '../flutter_artist.dart';

class BlockFragmentWidgetBuilder extends StatefulWidget {
  final Block block;
  final Object ownerClassInstance;
  final String? description;
  final Widget Function(Block blk) build;

  const BlockFragmentWidgetBuilder({
    super.key,
    required this.ownerClassInstance,
    required this.description,
    required this.block,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _BlockFragmentWidgetBuilderState();
  }
}

class _BlockFragmentWidgetBuilderState
    extends _WidgetState<BlockFragmentWidgetBuilder> {
  late final String keyId;

  @override
  String get locationInfo => getClassName(widget.ownerClassInstance);

  @override
  String get description {
    return widget.description == null || widget.description!.trim().isEmpty
        ? "${getClassName(widget.block)} (Block Fragment)"
        : widget.description!;
  }

  @override
  WidgetStateType get type => WidgetStateType.blockFragment;

  @override
  void refreshState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //
    keyId = _generateVisibilityDetectorId(prefix: getClassName(widget.block));
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
          ? widget.build(widget.block)
          : _DevContainer(
              child: widget.build(widget.block),
            ),
    );
  }

  void _addWidgetStateListener({required bool isShowing}) {
    widget.block._addWidgetStateListener(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.block._removeWidgetStateListener(widgetState: this);
  }
}
