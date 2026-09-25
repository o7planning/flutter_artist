part of '../core.dart';

/// Runtime workflow coordinator maintaining multi-stage progression and transitions.
class XFlow<
STAGE_ENUM extends Enum, //
FLOW_CONTEXT_DATA extends FlowContextData> {
  final XActivity xActivity;
  final Flow<STAGE_ENUM, FLOW_CONTEXT_DATA> flow;

  final Map<STAGE_ENUM, XStage> xStageMap = {};
  final List<XStage> allXStages = [];

  String get name => flow.name;

  int get xActivityId => xActivity.xActivityId;

  XFlow._({
    required this.xActivity,
    required this.flow,
  }) {
    for (final Stage stage in flow.stages) {
      final xStage = stage._createXStage(
        xFlow: this,
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
