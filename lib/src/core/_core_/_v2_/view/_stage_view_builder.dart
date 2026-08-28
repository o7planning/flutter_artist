part of '../../core.dart';

class StageViewBuilder extends _ContextProviderView {
  final Stage stage;
  final QuickSuggestionMode quickSuggestionMode;
  final Widget Function() build;

  const StageViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.stage,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _StageViewBuilderState();
  }
}

class _StageViewBuilderState
    extends _ContextProviderViewState<StageViewBuilder> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.stageView;

  @override
  Shelf? _getRelatedShelf() {
    return null;
  }

  @override
  Activity? _getRelatedActivity() {
    return widget.stage.activity;
  }

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.stage);
  }

  @override
  bool get provideScalarContext {
    return false;
  }

  @override
  bool get provideBlockContext {
    return false;
  }

  @override
  bool get provideItemContext {
    return false;
  }

  @override
  bool get provideFormContext {
    return false;
  }

  @override
  void addWidgetState({required bool isVisible}) {
    widget.stage.ui._addStageBaseViewWidgetState(
      widgetState: this,
      isVisible: isVisible,
    );
  }

  @override
  void removeWidgetState() {
    widget.stage.ui._removeStageBaseViewWidgetState(
      widgetState: this,
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    if (widget.quickSuggestionMode == QuickSuggestionMode.showIfError) {
      return Stack(
        children: [
          widget.build(),
          if (widget.stage.hasError)
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
            widget.stage.showStageErrorViewerDialog(context);
          },
        ),
        _QuickSuggestionButton.requery(
          tooltip: "Requery",
          onPressed: () async {
            await widget.stage.query();
          },
        ),
      ],
    );
  }

  @override
  void checkAndFreeMemory() {
    // FlutterArtist.storage._checkToRemoveShelf(widget.stage.shelf);
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
