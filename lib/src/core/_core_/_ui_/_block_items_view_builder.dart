part of '../core.dart';

class BlockItemsViewBuilder extends _ContextProviderView {
  final Block block;
  final QuickSuggestionMode quickSuggestionMode;
  final Widget Function() build;
  final bool provideItemContext;
  final bool provideFormContext;

  const BlockItemsViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.block,
    this.provideItemContext = false,
    this.provideFormContext = false,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
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
  String getWidgetOwnerClassName() {
    return getClassName(widget.block);
  }

  @override
  ContextProviderViewType get type => ContextProviderViewType.blockItemsView;

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
    return widget.provideItemContext;
  }

  @override
  bool get provideFormContext {
    return widget.provideFormContext;
  }

  @override
  bool get provideHookContext {
    return false;
  }

  @override
  void addWidgetState({required bool isVisible}) {
    widget.block.ui._addBlockBaseViewWidgetState(
      widgetState: this,
      isVisible: isVisible,
    );
  }

  @override
  void removeWidgetState() {
    widget.block.ui._removeBlockBaseViewWidgetState(
      widgetState: this,
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    if (widget.quickSuggestionMode == QuickSuggestionMode.showIfError) {
      return Stack(
        children: [
          widget.build(),
          if (widget.block.dataState == DataState.error)
            Positioned(
              top: 5,
              right: 5,
              child: _buildQuickSuggestionButtonsBar(context),
            ),
        ],
      );
    } else {
      return widget.build();
    }
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
        _QuickSuggestionButton.reQuery(
          tooltip: "Re Query",
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
