part of '../../flutter_artist.dart';

class BlockFragmentViewBuilder extends _RefreshableWidget {
  final Block block;
  final Widget Function() build;

  const BlockFragmentViewBuilder({
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
    extends _RefreshableWidgetState<BlockFragmentViewBuilder> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.block);
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.blockFragment;

  @override
  void addWidgetState({required bool isShowing}) {
    widget.block._addBlockFragmentWidgetState(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeWidgetState() {
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

  @override
  void executeAfterBuild() {
    // Do nothing.
  }

  @override
  void setBuildingState({required bool isBuilding}) {
    //
  }
}
