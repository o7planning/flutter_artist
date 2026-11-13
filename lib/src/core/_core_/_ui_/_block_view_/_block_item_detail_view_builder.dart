part of '../../core.dart';

class BlockItemDetailViewBuilder extends _ContextProviderView {
  final Block block;
  final Widget Function() build;

  @override
  final BlockItemDetailViewConfig config;

  BlockItemDetailViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.block,
    BlockItemDetailViewConfig? config,
    required this.build,
  })  : config = config ?? const BlockItemDetailViewConfig(),
        assert(
          config == null ||
              config.blockViewContext == BlockViewContext.itemDetail ||
              config.blockViewContext == BlockViewContext.form,
        );

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
    return "BlockItemDetailView(${widget.block.name})";
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

  // @override
  // Widget _buildQuickSuggestionButtonsBar(BuildContext context) {
  //   return SizedBox();
  // }

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
