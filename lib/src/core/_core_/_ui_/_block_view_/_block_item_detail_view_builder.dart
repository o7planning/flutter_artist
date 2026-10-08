part of '../../core.dart';

class BlockItemDetailViewBuilder extends _ContextProviderView {
  final Block block;
  final Widget Function() build;
  final BlockViewContext blockViewContext;

  const BlockItemDetailViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.block,
    this.blockViewContext = BlockViewContext.itemDetail,
    required this.build,
  }) : assert(blockViewContext == BlockViewContext.itemDetail ||
      blockViewContext == BlockViewContext.form);

  @override
  State<StatefulWidget> createState() {
    return _BlockItemDetailViewBuilderState();
  }
}

class _BlockItemDetailViewBuilderState
    extends _ContextProviderViewState<BlockItemDetailViewBuilder> {
  @override
  Shelf? _getRelatedModule() {
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
  BlockViewContext? get blockViewContext => widget.blockViewContext;

  @override
  ScalarViewContext? get scalarContextType => null;

  @override
  ProzessViewContext? get prozessViewContext => null;

  @override
  StageViewContext? get stageViewContext => null;

  @override
  TaskViewContext? get taskViewContext => null;

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
