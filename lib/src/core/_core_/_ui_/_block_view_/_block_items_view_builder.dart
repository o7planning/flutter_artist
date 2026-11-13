part of '../../core.dart';

class BlockItemsViewBuilder extends _ContextProviderView {
  final Block block;
  final Widget Function() build;

  @override
  final BlockItemsViewConfig config;

  const BlockItemsViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.block,
    BlockItemsViewConfig? config,
    required this.build,
  }) : config = config ?? const BlockItemsViewConfig();

  @override
  State<StatefulWidget> createState() {
    return _BlockItemsViewBuilderState();
  }
}

class _BlockItemsViewBuilderState
    extends _ContextProviderViewState<BlockItemsViewBuilder> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.blockItemsView;

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
  KeyEventResult onKeyEvent(FocusNode node, KeyEvent event) {
    // 1. Handle standard Up / Down / Home / End list navigation
    final navResult = _ViewFocusUtils.handleBlockItemsKeyEvent(
      block: widget.block,
      event: event,
    );
    if (navResult == KeyEventResult.handled) {
      return KeyEventResult.handled;
    }

    // 2. Handle Mnemonic Shortcuts (Alt+C, Alt+E, Alt+D, Alt+Q, Alt+R, etc.)
    return _BlockMnemonicHandler.handleKeyEvent(
      context: context,
      block: widget.block,
      screenNavigationContext: widget.config.screenNavigationContext,
      event: event,
    );
  }

  @override
  String getDebugLabel() {
    return "BlockItemsView(${widget.block.name})";
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
