part of '../../../core.dart';

class _XActivityTaskLoadInitData extends _XActivityBaseExec {
  _XActivityTaskLoadInitData({
    required Task task,
  }) : super(
          xActivityType: XActivityType.taskLoadInitData,
          activity: task.activity,
        ) {
    _updateExecStateFromTarget(
      targetTaskAndOptions: TargetTaskAndOptions(task: task),
      targetStageAndOptions: null,
    );
  }
}
