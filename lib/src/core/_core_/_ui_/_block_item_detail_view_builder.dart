part of '../core.dart';

class BlockItemDetailViewBuilder extends _RefreshableWidget {
  final Block block;
  final Widget Function() build;

  const BlockItemDetailViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.block,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _BlockItemDetailViewBuilderState();
  }
}

class _BlockItemDetailViewBuilderState
    extends _RefreshableWidgetState<BlockItemDetailViewBuilder> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.block);
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.blockItemDetailView;

  @override
  bool get isScalarRepresentative {
    return false;
  }

  @override
  bool get isBlockRepresentative {
    return true;
  }

  @override
  bool get isItemRepresentative {
    return true;
  }

  @override
  bool get isHookRepresentative {
    return false;
  }

  @override
  void addWidgetState({required bool isShowing}) {
    widget.block.ui._addBlockPieceWidgetState(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeWidgetState() {
    widget.block.ui._removeBlockPieceWidgetState(
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
