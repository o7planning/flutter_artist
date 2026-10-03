part of '../../core.dart';

class _TaskSubmitExecutionUnit<
    TASK_INIT_DATA extends TaskInitData, //
    TASK_RESULT_DATA extends TaskResultData,
    FORM_INPUT extends FormInput,
    FORM_OUTPUT extends FormOutput> extends _ActivityMemberExecutionUnit {
  final XTask<
      TASK_INIT_DATA, //
      TASK_RESULT_DATA,
      FORM_INPUT,
      FORM_OUTPUT> xTask;

  @override
  final TaskSubmitIntent<TASK_INIT_DATA, TASK_RESULT_DATA, FORM_OUTPUT>
      executionIntent;

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
