part of '../../../core.dart';

class _XActivityBaseExec extends XActivity {
  _XActivityBaseExec({
    required super.xActivityType,
    required super.activity,
  });

  void _updateExecStateFromTarget({
    required TargetTaskAndOptions? targetTaskAndOptions,
    required TargetStageAndOptions? targetStageAndOptions,
  }) {
    if (targetTaskAndOptions != null) {
      final Task targetTask = targetTaskAndOptions.task;
      final XTask targetXTask = xTaskMap[targetTask.name]!;
      targetXTask.setExecHintToGreater(ExecHint.force);
      // targetXTask.setOptions();
    }

    if (targetStageAndOptions != null) {
      final Stage targetStage = targetStageAndOptions.stage;
      final XStage targetXStage = xStageMap[targetStage.name]!;
      targetXStage.setExecHintToGreater(ExecHint.force);
      // targetXStage.setOptions();
    }
  }
}
