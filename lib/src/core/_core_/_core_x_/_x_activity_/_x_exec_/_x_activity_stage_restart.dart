part of '../../../core.dart';

class _XActivityStageRestart extends _XActivityBaseExec {
  _XActivityStageRestart({
    required Stage stage,
  }) : super(
    xActivityType: XActivityType.stageRestart,
    activity: stage.activity,
  ) {
    //
  }
}
