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
  bool get provideScalarContext {
    return false;
  }

  @override
  bool get provideBlockContext {
    return true;
  }

  @override
  bool get provideItemContext {
    return false;
  }

  @override
  bool get provideFormContext {
    return false;
  }

  @override
  bool get provideHookContext {
    return false;
  }

  @override
  Widget buildContent(BuildContext context) {
    return widget.build();
  }

  @override
  void addWidgetState({required bool isVisible}) {
    widget.block.ui._addPaginationWidgetState(
      widgetState: this,
      isVisible: isVisible,
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
