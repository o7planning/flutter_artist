part of '../../core.dart';

class _TaskExecutionUnit<
        TASK_DATA extends TaskData, //
        CREATION_PRESET extends CreationPreset,
        TASK_INPUT extends FormInput >
    extends _ActivityMemberExecutionUnit {
  final XTask<
      TASK_DATA, //
      CREATION_PRESET,
      TASK_INPUT > xTask;

  @override
  final TaskExecutionIntent<TASK_DATA> executionIntent;

  _TaskExecutionUnit({
    required this.xTask,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.task,
          executionIntent: executionIntent,
        );

  @override
  Activity get activity => xTask.task.activity;

  @override
  String getObjectName() {
    return xTask.task.name;
  }

  @override
  Object get owner => xTask.task;

  @override
  XActivity get xActivity => xTask.xActivity;

  @override
  int get xActivityId => xTask.xActivity.xActivityId;
}
