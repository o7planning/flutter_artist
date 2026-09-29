part of '../../../core.dart';

class _XActivityStageLoadInitData extends _XActivityBaseExec {
  _XActivityStageLoadInitData({
    required Stage stage,
  }) : super(
    xActivityType: XActivityType.stageLoadInitData,
    activity: stage.activity,
  ) {
    //
  }
}
