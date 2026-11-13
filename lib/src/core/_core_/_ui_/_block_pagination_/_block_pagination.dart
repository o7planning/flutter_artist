part of '../../core.dart';

abstract class BlockPagination extends _ContextProviderView {
  final Block block;

  @override
  final PaginationConfig config;

  const BlockPagination({
    super.key,
    required this.block,
    required super.description,
    required super.ownerClassInstance,
    this.config = const PaginationConfig(),
  });

  @override
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
  Shelf? _getRelatedModule() {
    return widget.block.shelf;
  }

  @override
  BlockViewContext? get blockViewContext => null;

  @override
  ScalarViewContext? get scalarContextType => null;

  @override
  ProzessViewContext? get prozessViewContext => null;

  @override
  StageViewContext? get stageViewContext => null;

  @override
  TaskViewContext? get taskViewContext => null;

  @override
  Widget buildContent(BuildContext context) {
    return widget.build(context);
  }

  @override
  String getDebugLabel() {
    return "Pagination(${widget.block.name})";
  }

  @override
  bool hasError() {
    return widget.block.hasError;
  }

  @override
  List<_QuickSuggestionButton> createQuickSuggestionButtons(
      BuildContext context) {
    return [];
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
