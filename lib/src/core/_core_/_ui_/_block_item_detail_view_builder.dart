part of '../core.dart';

class BlockItemDetailViewBuilder extends _ContextProviderView {
  final Block block;
  final Widget Function() build;
  final BlockContextType blockContextType;

  const BlockItemDetailViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.block,
    this.blockContextType = BlockContextType.itemDetail,
    required this.build,
  }) : assert(blockContextType == BlockContextType.itemDetail ||
            blockContextType == BlockContextType.form);

  @override
  State<StatefulWidget> createState() {
    return _BlockItemDetailViewBuilderState();
  }
}

class _BlockItemDetailViewBuilderState
    extends _ContextProviderViewState<BlockItemDetailViewBuilder> {
  @override
  Shelf? _getRelatedShelf() {
    return widget.block.shelf;
  }

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.block);
  }

  @override
  ContextProviderViewType get type =>
      ContextProviderViewType.blockItemDetailView;

  @override
  BlockContextType? get blockContextType => widget.blockContextType;

  @override
  ScalarContextType? get scalarContextType => null;

  @override
  StageContextType? get stageContextType => null;

  @override
  TaskContextType? get taskContextType => null;

  @override
  void addWidgetState({required bool isVisible}) {
    widget.block.ui._addBlockContentViewWidgetState(
      widgetState: this,
      isVisible: isVisible,
    );
  }

  @override
  void removeWidgetState() {
    widget.block.ui._removeBlockContentViewWidgetState(
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
