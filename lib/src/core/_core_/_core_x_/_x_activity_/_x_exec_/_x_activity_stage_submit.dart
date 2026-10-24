part of '../../../core.dart';

class _XActivityStageSubmit extends _XActivityBaseExec {
  _XActivityStageSubmit({
    required Stage stage,
  }) : super(
    xActivityType: XActivityType.submit,
    activity: stage.activity,
  ) {
    //
  }
}
