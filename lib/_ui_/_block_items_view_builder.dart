part of '../flutter_artist.dart';

class _BlockItemsViewBuilder extends _RefreshableWidget {
  final Block block;
  final Widget Function() build;

  const _BlockItemsViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.block,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _BlockItemsViewBuilderState();
  }
}

class _BlockItemsViewBuilderState
    extends _RefreshableWidgetState<_BlockItemsViewBuilder> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.block);
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.blockItemsView;

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
