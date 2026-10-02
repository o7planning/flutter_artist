part of '../../../core.dart';

class _XActivityTaskSubmit extends _XActivityBaseExec {
  _XActivityTaskSubmit({
    required Task task,
  }) : super(
          xActivityType: XActivityType.submit,
          activity: task.activity,
        ) {
    //
  }
}
