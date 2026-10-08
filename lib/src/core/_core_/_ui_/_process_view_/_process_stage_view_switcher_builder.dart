part of '../../core.dart';

class ProzessStageViewSwitcherBuilder
    extends _BaseProzessStageViewSwitcherBuilder {
  final List<StageViewBuilder> stageViewBuilders;
  final List<StageView> stageViews;

  const ProzessStageViewSwitcherBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.stageViewBuilders,
    required this.stageViews,
    super.quickSuggestionMode,
  });

  @override
  State<StatefulWidget> createState() =>
      _ProzessStageViewSwitcherBuilderState();
}

class _ProzessStageViewSwitcherBuilderState
    extends _BaseProzessStageViewSwitcherBuilderState<
        ProzessStageViewSwitcherBuilder> {
  final Set<Stage> _stages = {};
  final Set<Prozess> _prozesses = {};
  Stage? _duplicatedStage;
  Prozess? _targetProzess;

  @override
  void initState() {
    super.initState();

    // Collect all stages from both StageView and StageViewBuilder items.
    final allStages = <Stage>[
      ...widget.stageViews.map((e) => e.stage),
      ...widget.stageViewBuilders.map((e) => e.stage),
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
  Prozess getProzess() {
    if (_targetProzess == null) {
      throw StateError(
          "ProzessStageViewSwitcher requires a valid target Prozess instance.");
    }
    return _targetProzess!;
  }

  @override
  Widget buildContent(BuildContext context) {
    // 1. Validate empty stage configuration.
    if (_stages.isEmpty) {
      return const ErrorMessageView(
        message:
            "Configuration Error: No Stage views were provided to the ProzessStageViewSwitcher container.",
      );
    }
    // 2. Validate prozess instance consistency across all stage views.
    else if (_prozesses.length > 1) {
      return const ErrorMessageView(
        message:
            "Architectural Violation: All configured Stage views must belong to the exact same Prozess instance.",
      );
    }
    // 3. Validate duplicate stage definitions.
    else if (_duplicatedStage != null) {
      return ErrorMessageView(
        message:
            "Configuration Error: Duplicate Stage '${getClassName(_duplicatedStage)}' detected inside ProzessStageViewSwitcher.",
      );
    }

    return super.buildContent(context);
  }

  @override
  List<Widget> buildStageWidgets(BuildContext context) {
    // Map stage instances to their corresponding UI widgets.
    final Map<Stage, Widget> stageWidgetMap = {};

    for (final view in widget.stageViews) {
      stageWidgetMap[view.stage] = view;
    }
    for (final builder in widget.stageViewBuilders) {
      stageWidgetMap[builder.stage] = builder;
    }

    // Construct sorted widget list matching the prozess's canonical `orderedStages`.
    final List<Widget> sortedWidgets = [];
    for (final orderedStage in prozess.orderedStages) {
      final widgetItem = stageWidgetMap[orderedStage];
      if (widgetItem != null) {
        sortedWidgets.add(widgetItem);
      }
    }
    return sortedWidgets;
  }
}
