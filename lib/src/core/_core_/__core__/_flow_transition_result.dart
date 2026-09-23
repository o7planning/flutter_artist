part of '../core.dart';

class FlowTransitionResult<STAGE_ENUM extends Enum> {
  //
}

class StageExecutionResult<
    STAGE_ENUM extends Enum, //
    STAGE_DATA extends StageData> {
  final STAGE_DATA? stageData;
  final STAGE_ENUM? nextStage;
  final bool isFinished;

  StageExecutionResult.toStage({
    required this.nextStage,
    this.stageData,
  }) : isFinished = false;

  StageExecutionResult.completed({this.stageData})
      : nextStage = null,
        isFinished = true;
}
