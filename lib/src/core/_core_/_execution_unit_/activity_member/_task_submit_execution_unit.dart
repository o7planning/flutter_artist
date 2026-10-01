part of '../../core.dart';

class _TaskSubmitExecutionUnit<
TASK_INIT_DATA extends TaskInitData, //
TASK_RESULT_DATA extends TaskResultData,
TASK_INPUT extends FormInput> extends _ActivityMemberExecutionUnit {
  final XTask<
      TASK_INIT_DATA,
      TASK_RESULT_DATA, //
      TASK_INPUT> xTask;

  @override
  final TaskSubmitIntent<TASK_INIT_DATA, TASK_RESULT_DATA> executionIntent;

  _TaskSubmitExecutionUnit({
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
  int get xModuleId => xTask.xActivity.xModuleId;
}
