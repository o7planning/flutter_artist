part of '../../core.dart';

class _TaskExecutionUnit<
        TASK_DATA extends TaskData, //
        TASK_INPUT extends FormInput,
        ADDITIONAL_FORM_DATA extends AdditionalFormRelatedData>
    extends _ActivityMemberExecutionUnit {
  final XTask<
      TASK_DATA, //
      TASK_INPUT,
      ADDITIONAL_FORM_DATA> xTask;

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
