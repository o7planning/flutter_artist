part of '../../core.dart';

class BlockItemsViewBuilder extends _ContextProviderView {
  final Block block;
  final QuickSuggestionMode quickSuggestionMode;
  final Widget Function() build;
  final BlockViewContext blockViewContext;

  /// Whether this items view can receive keyboard focus and handle Up/Down arrow navigation.
  final bool enableKeyboardNavigation;

  /// Visual style used to highlight this region when it holds keyboard focus.
  final ViewFocusStyle focusStyle;

  /// Policy controlling whether clicking inside this view transfers keyboard focus to it.
  final ViewMouseFocusPolicy mouseFocusPolicy;

  const BlockItemsViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.block,
    this.blockViewContext = BlockViewContext.items,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    this.enableKeyboardNavigation = true,
    this.focusStyle = ViewFocusStyle.leftAccentBar,
    this.mouseFocusPolicy = ViewMouseFocusPolicy.strictNavigationOnly,
    required this.build,
  });

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
    Widget content;
    if (widget.quickSuggestionMode == QuickSuggestionMode.showIfError) {
      content = Stack(
        children: [
          widget.build(),
          if (widget.block.hasError)
            Positioned(
              top: 5,
              right: 5,
              child: _buildQuickSuggestionButtonsBar(context),
            ),
        ],
      );
    } else {
      content = widget.build();
    }

    return _FocusableViewRegion(
      debugLabel: 'BlockItemsView(${widget.block.name})',
      enabled: widget.enableKeyboardNavigation,
      focusStyle: widget.focusStyle,
      mouseFocusPolicy: widget.mouseFocusPolicy,
      onKeyEvent: (node, event) => _ViewFocusUtils.handleBlockItemsKeyEvent(
        block: widget.block,
        event: event,
      ),
      child: content,
    );
  }

  Widget _buildQuickSuggestionButtonsBar(BuildContext context) {
    return _QuickSuggestionButtonsBar(
      children: [
        _QuickSuggestionButton.error(
          tooltip: "Error",
          onPressed: () {
            widget.block.showBlockErrorViewerDialog(context);
          },
        ),
        _QuickSuggestionButton.requery(
          tooltip: "Requery",
          onPressed: () async {
            await widget.block.query();
          },
        ),
      ],
    );
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
