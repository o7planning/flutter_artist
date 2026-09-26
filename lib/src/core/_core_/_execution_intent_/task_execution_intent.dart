part of '../core.dart';

sealed class TaskBaseExecutionIntent<
        TASK_INIT_DATA extends TaskInitData, //
        TASK_RESULT_DATA extends TaskResultData,
        PRECHECK, //
        EXECUTION_RESULT extends ExecutionUnitResult<PRECHECK>>
    extends ExecutionIntent {
  //
}

class TaskLoadInitDataIntent<
    TASK_INIT_DATA extends TaskInitData, //
    TASK_RESULT_DATA extends TaskResultData> extends TaskBaseExecutionIntent<
    TASK_INIT_DATA,
    TASK_RESULT_DATA, //
    TaskSubmitExcutionPrecheck,
    TaskSubmitExecutionResult> {
  TaskLoadInitDataIntent();
}

class TaskSubmitIntent<
    TASK_INIT_DATA extends TaskInitData, //
    TASK_RESULT_DATA extends TaskResultData> extends TaskBaseExecutionIntent<
    TASK_INIT_DATA,
    TASK_RESULT_DATA, //
    TaskSubmitExcutionPrecheck,
    TaskSubmitExecutionResult> {
  TaskSubmitIntent();
}

class TaskDoneIntent<
    TASK_INIT_DATA extends TaskInitData, //
    TASK_RESULT_DATA extends TaskResultData> extends TaskBaseExecutionIntent<
    TASK_INIT_DATA,
    TASK_RESULT_DATA, //
    TaskSubmitExcutionPrecheck,
    TaskSubmitExecutionResult> {
  final String lastIntentInfo;

  TaskDoneIntent({required this.lastIntentInfo});
}

class TaskNullIntent<
        TASK_INIT_DATA extends TaskInitData, TASK_RESULT_DATA extends TaskResultData>
    extends TaskBaseExecutionIntent<
        TASK_INIT_DATA,
        TASK_RESULT_DATA, //
        TaskSubmitExcutionPrecheck,
        TaskSubmitExecutionResult> {
  final String lastIntentInfo;

  TaskNullIntent({required this.lastIntentInfo});
}
