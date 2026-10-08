part of '../core.dart';

sealed class TaskBaseExecutionIntent<
        TASK_INIT_DATA extends TaskInitData, //
        TASK_RESULT_DATA extends TaskResultData,
        PRECHECK, //
        EXECUTION_RESULT extends ExecutionUnitResult<PRECHECK>>
    extends ExecutionIntent<PRECHECK, EXECUTION_RESULT> {
  TaskBaseExecutionIntent();
}

class TaskLoadInitDataIntent<
    TASK_INIT_DATA extends TaskInitData, //
    TASK_RESULT_DATA extends TaskResultData> extends TaskBaseExecutionIntent<
    TASK_INIT_DATA,
    TASK_RESULT_DATA, //
    TaskLoadInitDataPrecheck,
    TaskLoadInitDataResult<TASK_INIT_DATA, TASK_RESULT_DATA>> {
  TaskLoadInitDataIntent();
}

class TaskSubmitIntent<
    TASK_INIT_DATA extends TaskInitData, //
    TASK_RESULT_DATA extends TaskResultData,
    FORM_OUTPUT extends FormOutput> extends TaskBaseExecutionIntent<
    TASK_INIT_DATA,
    TASK_RESULT_DATA, //
    TaskSubmitPrecheck,
    TaskSubmitExecutionResult<TASK_INIT_DATA, TASK_RESULT_DATA>> {
  TaskSubmitIntent();
}

class TaskDoneIntent<
    TASK_INIT_DATA extends TaskInitData, //
    TASK_RESULT_DATA extends TaskResultData> extends TaskBaseExecutionIntent<
    TASK_INIT_DATA,
    TASK_RESULT_DATA, //
    dynamic,
    EmptyExecutionUnitResult> {
  final String lastIntentInfo;

  TaskDoneIntent({required this.lastIntentInfo});
}

class TaskNullIntent<
    TASK_INIT_DATA extends TaskInitData, //
    TASK_RESULT_DATA extends TaskResultData> extends TaskBaseExecutionIntent<
    TASK_INIT_DATA,
    TASK_RESULT_DATA, //
    dynamic,
    EmptyExecutionUnitResult> {
  final String lastIntentInfo;

  TaskNullIntent({required this.lastIntentInfo});
}
