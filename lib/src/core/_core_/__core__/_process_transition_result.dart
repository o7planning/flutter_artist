part of '../core.dart';

class ProzessTransitionResult<STAGE_ENUM extends StageEnum> {
  //
}

@Deprecated("Khong dung nua")
class NextStageDeterminationOutcome<
    STAGE_ENUM extends StageEnum, //
    STAGE_DATA extends StageResultData> {
  final STAGE_DATA? stageData;
  final STAGE_ENUM? nextStageEnum;
  final ErrorInfo? errorInfo;
  final bool isFinished;

  NextStageDeterminationOutcome.error({
    required ErrorInfo this.errorInfo,
    this.stageData,
  })  : isFinished = false,
        nextStageEnum = null;

  NextStageDeterminationOutcome.hasNextStage({
    required STAGE_ENUM this.nextStageEnum,
    this.stageData,
  })  : isFinished = false,
        errorInfo = null;

  NextStageDeterminationOutcome.completed({this.stageData})
      : nextStageEnum = null,
        isFinished = true,
        errorInfo = null;
}
