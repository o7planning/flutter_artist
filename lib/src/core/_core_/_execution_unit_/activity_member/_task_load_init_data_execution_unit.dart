part of '../../core.dart';

class _TaskLoadInitDataExecutionUnit<
TASK_INIT_DATA extends TaskInitData, //
TASK_RESULT_DATA extends TaskResultData,
FORM_INPUT extends FormInput> extends _ActivityMemberExecutionUnit {
  final XTask xTask;

  @override
  final TaskLoadInitDataIntent<
      TASK_INIT_DATA, //
      TASK_RESULT_DATA> executionIntent;

  _TaskLoadInitDataExecutionUnit({
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
