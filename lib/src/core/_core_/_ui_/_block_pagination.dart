part of '../core.dart';

abstract class BlockPagination extends _RefreshableWidget {
  final Block block;

  const BlockPagination({
    super.key,
    required this.block,
    required super.description,
    required super.ownerClassInstance,
  });

  Widget build();

  @override
  State<StatefulWidget> createState() {
    return _BlockPaginationState();
  }
}

class _BlockPaginationState extends _RefreshableWidgetState<BlockPagination> {
  @override
  RefreshableWidgetType get type => RefreshableWidgetType.pagination;

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
    return false;
  }

  @override
  Widget buildContent(BuildContext context) {
    return widget.build();
  }

  @override
  void addWidgetState({required bool isShowing}) {
    widget.block.ui._addPaginationWidgetState(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeWidgetState() {
    widget.block.ui._removePaginationWidgetState(
      widgetState: this,
    );
  }

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.block);
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
