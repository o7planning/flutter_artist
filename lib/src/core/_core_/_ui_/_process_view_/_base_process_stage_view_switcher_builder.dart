part of '../../core.dart';

/// Abstract base builder providing core lifecycle management, error handling,
/// and quick suggestion toolbars for prozess stage switchers.
abstract class _BaseProzessStageViewSwitcherBuilder
    extends _ContextProviderView {
  final QuickSuggestionMode quickSuggestionMode;

  const _BaseProzessStageViewSwitcherBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
  });
}

abstract class _BaseProzessStageViewSwitcherBuilderState<
        W extends _BaseProzessStageViewSwitcherBuilder>
    extends _ContextProviderViewState<W> {
  Prozess get prozess => getProzess();

  /// Abstract contract for subclasses to supply the active target prozess instance.
  Prozess getProzess();

  /// Abstract contract for subclasses to supply the sorted list of stage widgets to render inside the stack.
  List<Widget> buildStageWidgets(BuildContext context);

  @override
  ContextProviderViewType get type =>
      ContextProviderViewType.prozessStageViewSwitcher;

  @override
  Activity? _getRelatedModule() => prozess.activity;

  @override
  String getWidgetOwnerClassName() => getClassName(prozess);

  @override
  BlockViewContext? get blockViewContext => null;

  @override
  ScalarViewContext? get scalarContextType => null;

  @override
  ProzessViewContext? get prozessViewContext => ProzessViewContext.initData;

  @override
  StageViewContext? get stageViewContext => null;

  @override
  TaskViewContext? get taskViewContext => null;

  @override
  void addWidgetState({required bool isVisible}) {
    prozess.ui._addProzessContentViewWidgetState(
      widgetState: this,
      isVisible: isVisible,
    );
  }

  @override
  void removeWidgetState() {
    prozess.ui._removeProzessContentViewWidgetState(
      widgetState: this,
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    // If prozess is still pending initialization, render a safe empty placeholder
    // to prevent premature mounting and wasted initialization cycles.
    if (prozess.dataState.isPending) {
      return const SizedBox.shrink();
    }

    final Widget content = _buildSortedStagesStack(context);

    if (widget.quickSuggestionMode == QuickSuggestionMode.showIfError &&
        prozess.hasError) {
      return Stack(
        children: [
          content,
          Positioned(
            top: 5,
            right: 5,
            child: _buildQuickSuggestionButtonsBar(context),
          ),
        ],
      );
    }

    return content;
  }

  /// Builds the sorted IndexedStack for stages wrapped inside a switcher scope.
  Widget _buildSortedStagesStack(BuildContext context) {
    final List<Widget> sortedWidgets = buildStageWidgets(context);

    // Determine current index based on the prozess's viewingStageEnum pointer.
    final int currentIndex = prozess.orderedStages.indexWhere(
      (stage) => stage.stageId == prozess.viewingStageEnum,
    );

    return _StageViewSwitcherScope(
      child: IndexedStack(
        index: currentIndex >= 0 ? currentIndex : 0,
        children: sortedWidgets,
      ),
    );
  }

  Widget _buildQuickSuggestionButtonsBar(BuildContext context) {
    return _QuickSuggestionButtonsBar(
      children: [
        _QuickSuggestionButton.error(
          tooltip: "View Error Diagnostics",
          onPressed: () {
            prozess.showProzessErrorViewerDialog(context);
          },
        ),
        _QuickSuggestionButton.requery(
          tooltip: "Reload Prozess Init Data",
          onPressed: () async {
            await prozess.loadInitData();
          },
        ),
      ],
    );
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.desk._checkToRemoveActivity(prozess.activity);
  }

  @override
  void executeAfterBuild() {
    // Do nothing.
  }

  @override
  void setBuildingState({required bool isBuilding}) {
    // Do nothing.
  }
}
