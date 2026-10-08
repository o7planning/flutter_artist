part of '../core.dart';

abstract class BlockPagination extends _ContextProviderView {
  final Block block;

  const BlockPagination({
    super.key,
    required this.block,
    required super.description,
    required super.ownerClassInstance,
  });

  Widget build(BuildContext context);

  @override
  State<StatefulWidget> createState() {
    return _BlockPaginationState();
  }
}

class _BlockPaginationState extends _ContextProviderViewState<BlockPagination> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.pagination;

  @override
  Shelf? _getRelatedShelf() {
    return widget.block.shelf;
  }



  @override
  BlockContextType? get blockContextType => null;

  @override
  ScalarContextType? get scalarContextType => null;

  @override
  StageContextType? get stageContextType => null;

  @override
  TaskContextType? get taskContextType => null;

  @override
  Widget buildContent(BuildContext context) {
    return widget.build(context);
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
