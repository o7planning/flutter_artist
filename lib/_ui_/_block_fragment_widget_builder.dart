part of '../flutter_artist.dart';

class BlockFragmentWidgetBuilder extends _StatefulWidget {
  final Block block;
  final Widget Function(Block blk) build;

  const BlockFragmentWidgetBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
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
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.block);
  }

  @override
  WidgetStateType get type => WidgetStateType.blockFragment;

  @override
  void addWidgetStateListener({required bool isShowing}) {
    widget.block._addWidgetStateListener(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeWidgetStateListener() {
    widget.block._removeWidgetStateListener(
      widgetState: this,
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return widget.build(widget.block);
  }
}
