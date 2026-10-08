part of '../core.dart';

class StageViewBuilder extends _ContextProviderView {
  final Stage stage;
  final QuickSuggestionMode quickSuggestionMode;
  final Widget Function() build;
  final StageContextType  stageContextType;

  const StageViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.stage,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    this.stageContextType= StageContextType.initData,
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
  String getWidgetOwnerClassName() {
    return getClassName(widget.stage);
  }

  @override
  BlockContextType? get blockContextType => null;

  @override
  ScalarContextType? get scalarContextType => null;

  @override
  StageContextType? get stageContextType => widget.stageContextType;

  @override
  TaskContextType? get taskContextType => null;

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
          tooltip: "Load Init Data",
          onPressed: () async {
            await widget.stage.loadInitData();
          },
        ),
      ],
    );
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.desk._checkToRemoveActivity(widget.stage.activity);
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
