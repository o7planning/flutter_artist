part of '../flutter_artist.dart';

class NonBlockFragmentWidgetBuilder extends StatefulWidget {
  final NonBlock nonBlock;
  final Object ownerClassInstance;
  final String? description;
  final Widget Function(NonBlock blk) build;

  const NonBlockFragmentWidgetBuilder({
    super.key,
    required this.ownerClassInstance,
    required this.description,
    required this.nonBlock,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _NonBlockFragmentWidgetBuilderState();
  }
}

class _NonBlockFragmentWidgetBuilderState
    extends _WidgetState<NonBlockFragmentWidgetBuilder> {
  late final String keyId;

  @override
  String get locationInfo => getClassName(widget.ownerClassInstance);

  @override
  String get description {
    return widget.description == null || widget.description!.trim().isEmpty
        ? "${getClassName(widget.nonBlock)} (NonBlock Fragment)"
        : widget.description!;
  }

  @override
  WidgetStateType get type => WidgetStateType.nonBlockFragment;

  @override
  void refreshState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //
    keyId =
        _generateVisibilityDetectorId(prefix: getClassName(widget.nonBlock));
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
          ? widget.build(widget.nonBlock)
          : _DevContainer(
              child: widget.build(widget.nonBlock),
            ),
    );
  }

  void _addWidgetStateListener({required bool isShowing}) {
    widget.nonBlock._addWidgetStateListener(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.nonBlock._removeWidgetStateListener(widgetState: this);
  }
}
