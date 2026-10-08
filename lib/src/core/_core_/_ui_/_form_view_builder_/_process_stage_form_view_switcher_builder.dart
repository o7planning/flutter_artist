part of '../../core.dart';

class ProzessStageFormViewSwitcherBuilder extends _ContextProviderView {
  final QuickSuggestionMode quickSuggestionMode;
  final List<StageFormViewBuilder> stageFormViewBuilders;
  final List<StageFormView> stageFormViews;

  const ProzessStageFormViewSwitcherBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.stageFormViewBuilders,
    required this.stageFormViews,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
  });

  @override
  State<StatefulWidget> createState() {
    return _ProzessStageFormViewSwitcherBuilderState();
  }
}

class _ProzessStageFormViewSwitcherBuilderState
    extends _ContextProviderViewState<ProzessStageFormViewSwitcherBuilder> {
  final Set<Stage> _stages = {};
  final Set<Prozess> _prozesses = {};
  Stage? _duplicatedStage;
  Prozess? _targetProzess;

  @override
  void initState() {
    super.initState();

    // Collect all stages from both StageFormView and StageFormViewBuilder items.
    final allStages = <Stage>[
      ...widget.stageFormViews.map((e) => e.formModel.stage),
      ...widget.stageFormViewBuilders.map((e) => e.formModel.stage),
    ];

    for (final stage in allStages) {
      if (_stages.contains(stage)) {
        _duplicatedStage = stage;
      }
      _stages.add(stage);
      _prozesses.add(stage.prozess);
    }

    if (_prozesses.length == 1) {
      _targetProzess = _prozesses.first;
    }
  }

  @override
  ContextProviderViewType get type =>
      ContextProviderViewType.prozessStageViewSwitcher;

  @override
  Activity? _getRelatedModule() {
    return _targetProzess?.activity;
  }

  @override
  String getWidgetOwnerClassName() {
    return _targetProzess?.name ?? "";
  }

  @override
  BlockViewContext? get blockViewContext => null;

  @override
  ScalarViewContext? get scalarContextType => null;

  @override
  ProzessViewContext? get prozessViewContext => ProzessViewContext.initData;

  @override
  StageViewContext? get stageViewContext => StageViewContext.form;

  @override
  TaskViewContext? get taskViewContext => null;

  @override
  void addWidgetState({required bool isVisible}) {
    for (final prozess in _prozesses) {
      prozess.ui._addProzessContentViewWidgetState(
        widgetState: this,
        isVisible: isVisible,
      );
    }
  }

  @override
  void removeWidgetState() {
    for (final prozess in _prozesses) {
      prozess.ui._removeProzessContentViewWidgetState(
        widgetState: this,
      );
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    // 1. Validate empty stage form configuration.
    if (_stages.isEmpty) {
      return const ErrorMessageView(
        message:
            "Configuration Error: No Stage form views were provided to the ProzessStageFormsSwitching container.",
      );
    }
    // 2. Validate prozess instance consistency across all stage form views.
    else if (_prozesses.length > 1) {
      return const ErrorMessageView(
        message:
            "Architectural Violation: All configured Stage form views must belong to the exact same Prozess instance.",
      );
    }
    // 3. Validate duplicate stage form definitions.
    else if (_duplicatedStage != null) {
      return ErrorMessageView(
        message:
            "Configuration Error: Duplicate Stage form for '${getClassName(_duplicatedStage)}' detected inside ProzessStageFormViewSwitcher.",
      );
    }

    final prozess = _targetProzess!;

    if (widget.quickSuggestionMode == QuickSuggestionMode.showIfError) {
      return Stack(
        children: [
          _buildSortedFormsStack(prozess),
          if (prozess.hasError)
            Positioned(
              top: 5,
              right: 5,
              child: _buildQuickSuggestionButtonsBar(context, prozess),
            ),
        ],
      );
    } else {
      return _buildSortedFormsStack(prozess);
    }
  }

  /// Builds the sorted IndexedStack for stage forms, or a safe empty placeholder
  /// if the prozess is still pending and has not yet determined its active viewing stage.
  Widget _buildSortedFormsStack(Prozess prozess) {
    // If prozess is still pending initialization, render an empty container
    // to prevent premature form mounting and wasted initialization cycles.
    if (prozess.dataState.isPending) {
      return const SizedBox.shrink();
    }

    // Map stage instances to their corresponding form widgets.
    final Map<Stage, Widget> formWidgetMap = {};

    for (final view in widget.stageFormViews) {
      formWidgetMap[view.formModel.stage] = view;
    }
    for (final builder in widget.stageFormViewBuilders) {
      formWidgetMap[builder.formModel.stage] = builder;
    }

    // Construct sorted widget list matching the prozess's canonical `orderedStages`.
    final List<Widget> sortedWidgets = [];
    for (final orderedStage in prozess.orderedStages) {
      final widgetItem = formWidgetMap[orderedStage];
      if (widgetItem != null) {
        sortedWidgets.add(widgetItem);
      }
    }

    // Determine current index based on the prozess's viewingStageEnum pointer.
    final int currentIndex = prozess.orderedStages.indexWhere(
      (stage) => stage.stageId == prozess.viewingStageEnum,
    );

    return _StageFormViewSwitcherScope(
      child: IndexedStack(
        index: currentIndex >= 0 ? currentIndex : 0,
        children: sortedWidgets,
      ),
    );
  }

  Widget _buildQuickSuggestionButtonsBar(
      BuildContext context, Prozess prozess) {
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
    for (final prozess in _prozesses) {
      FlutterArtist.desk._checkToRemoveActivity(prozess.activity);
    }
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
