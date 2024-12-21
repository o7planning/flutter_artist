part of '../flutter_artist.dart';

class BlockFilterFragmentWidgetBuilder extends StatefulWidget {
  final BlockFilter blockFilter;
  final Object ownerClassInstance;
  final String? description;
  final Widget Function(BlockFilter blkFilter) build;

  const BlockFilterFragmentWidgetBuilder({
    super.key,
    required this.ownerClassInstance,
    required this.description,
    required this.blockFilter,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _BlockFilterFragmentWidgetBuilderState();
  }
}

class _BlockFilterFragmentWidgetBuilderState
    extends _WidgetState<BlockFilterFragmentWidgetBuilder> {
  late final String keyId;

  @override
  String get locationInfo => getClassName(widget.ownerClassInstance);

  @override
  String get description {
    return widget.description == null || widget.description!.trim().isEmpty
        ? "${getClassName(widget.blockFilter)} (Filter)"
        : widget.description!;
  }

  @override
  WidgetStateType get type => WidgetStateType.filter;

  @override
  void refreshState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //
    keyId = _generateVisibilityDetectorId(
      prefix: getClassName(widget.blockFilter),
    );
    //
    _addWidgetStateListener(isShowing: true);
  }

  @override
  void dispose() {
    super.dispose();
    widget.blockFilter._removeWidgetStateListener(widgetState: this);
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
          ? widget.build(widget.blockFilter)
          : _DevContainer(
              child: widget.build(widget.blockFilter),
            ),
    );
  }

  void _addWidgetStateListener({required bool isShowing}) {
    widget.blockFilter
        ._addWidgetStateListener(widgetState: this, isShowing: isShowing);
  }
}
