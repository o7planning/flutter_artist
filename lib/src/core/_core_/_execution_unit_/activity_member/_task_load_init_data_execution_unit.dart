part of '../../core.dart';

class _TaskRestartExecutionUnit<
    TASK_INIT_DATA extends TaskInitData, //
    TASK_RESULT_DATA extends TaskResultData,
    FORM_INPUT extends FormInput> extends _ActivityMemberExecutionUnit {
  final XTask xTask;

  @override
  final TaskRestartIntent<
      TASK_INIT_DATA, //
      TASK_RESULT_DATA> executionIntent;

  _TaskRestartExecutionUnit({
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
