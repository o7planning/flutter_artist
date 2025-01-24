part of '../flutter_artist.dart';

class BlockFragmentWidgetBuilder extends _RefreshableWidget {
  final Block block;
  final Widget Function() build;

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
    extends _RefreshableWidgetState<BlockFragmentWidgetBuilder> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.block);
  }

  @override
  WidgetStateType get type => WidgetStateType.blockFragment;

  @override
  void addFilterFragmentWidgetState({required bool isShowing}) {
    widget.block._addBlockFragmentWidgetState(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeFilterFragmentWidgetState() {
    widget.block._removeBlockFragmentWidgetState(
      widgetState: this,
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return widget.build();
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage._checkToRemoveShelf(widget.block.shelf);
  }
}
