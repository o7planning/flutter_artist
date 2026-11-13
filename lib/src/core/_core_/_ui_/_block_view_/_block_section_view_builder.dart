part of '../../core.dart';

class BlockSectionViewBuilder extends _ContextProviderView {
  final Block block;
  final Widget Function() build;
  @override
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
  ContextProviderViewType get type => ContextProviderViewType.blockSection;

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
  String getDebugLabel() {
    return "BlockSectionView(${widget.block.name})";
  }

  @override
  bool hasError() {
    return widget.block.hasError;
  }

  @override
  List<_QuickSuggestionButton> createQuickSuggestionButtons(
      BuildContext context) {
    return [
      QuickSuggestionBarUtils.createBlockErrorButton(context, widget.block),
      QuickSuggestionBarUtils.createBlockRequeryButton(context, widget.block),
    ];
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
