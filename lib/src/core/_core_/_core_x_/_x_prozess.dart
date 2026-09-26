part of '../core.dart';

/// Runtime workflow coordinator maintaining multi-stage progression and transitions.
class XProzess<
    STAGE_ENUM extends Enum, //
    PROZESS_CONTEXT_DATA extends ProzessContextData> {
  final XActivity xActivity;
  final Prozess<STAGE_ENUM, PROZESS_CONTEXT_DATA> flow;

  final Map<STAGE_ENUM, XStage> xStageMap = {};
  final List<XStage> allXStages = [];

  String get name => flow.name;

  int get xActivityId => xActivity.xActivityId;

  XProzess._({
    required this.xActivity,
    required this.flow,
  }) {
    for (final Stage stage in flow.stages) {
      final xStage = stage._createXStage(
        xProzess: this,
      );
      xStageMap[stage.stageId as STAGE_ENUM] = xStage;
      allXStages.add(xStage);
    }
  }

  // ***************************************************************************

  XStage? findXStageById(STAGE_ENUM stageId) => xStageMap[stageId];

  // ***************************************************************************

  /// Finds and yields the next executable task belonging to the active stage.
  NxtExecutionUnit? _getNextExecutionUnit({required bool debug}) {
    final activeStageId = flow.currentStageId;
    final activeXStage = xStageMap[activeStageId];

    if (activeXStage != null) {
      final next = activeXStage._getNextExecutionUnit(debug: debug);
      if (next.yes) {
        return next;
      }
    }
    return null;
  }
}
