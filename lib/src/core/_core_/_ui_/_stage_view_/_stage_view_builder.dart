part of '../../core.dart';

class StageViewBuilder extends _ContextProviderView {
  final Stage stage;
  final QuickSuggestionMode quickSuggestionMode;
  final Widget Function() build;
  final StageViewContext stageViewContext;

  const StageViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.stage,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    this.stageViewContext = StageViewContext.initData,
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
  Shelf? _getRelatedModule() {
    return null;
  }

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.stage);
  }

  @override
  BlockViewContext? get blockViewContext => null;

  @override
  ScalarViewContext? get scalarContextType => null;

  @override
  ProzessViewContext? get prozessViewContext => null;

  @override
  StageViewContext? get stageViewContext => widget.stageViewContext;

  @override
  TaskViewContext? get taskViewContext => null;

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
    final isValid = _StageViewSwitcherScope.maybeOf(context) != null;
    if (!isValid) {
      return ErrorMessageView(
        message: 'StageView and StageViewBuilder must be child widget '
            'of ProzessStageViewSwitcherBuilder or ProzessStageViewSwitcher!',
      );
    }
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
            // await widget.stage.loadInitData();
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
