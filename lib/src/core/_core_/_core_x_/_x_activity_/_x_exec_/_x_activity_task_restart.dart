part of '../../../core.dart';

class _XActivityTaskRestart extends _XActivityBaseExec {
  _XActivityTaskRestart({
    required Task task,
  }) : super(
          xActivityType: XActivityType.taskLoadInitData,
          activity: task.activity,
        ) {
     //
  }
}
