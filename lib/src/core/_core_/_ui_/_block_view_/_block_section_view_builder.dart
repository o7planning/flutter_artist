part of '../../core.dart';

class BlockSectionViewBuilder extends _ContextProviderView {
  final Block block;
  final Widget Function() build;
  final BlockSectionViewConfig config;

  const BlockSectionViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.block,
    BlockSectionViewConfig? config,
    required this.build,
  }) : config = config ?? const BlockSectionViewConfig();

  @override
  State<StatefulWidget> createState() {
    return _BlockSectionViewBuilderState();
  }
}

class _BlockSectionViewBuilderState
    extends _ContextProviderViewState<BlockSectionViewBuilder> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.blockFragment;

  @override
  Shelf? _getRelatedModule() {
    return widget.block.shelf;
  }

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.block);
  }

  @override
  BlockViewContext? get blockViewContext => widget.config.blockViewContext;

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
