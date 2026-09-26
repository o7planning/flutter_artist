part of '../core.dart';

sealed class TaskBaseExecutionIntent<
        TASK_INIT_DATA extends TaskInitData, //
        TASK_RESULT_DATA extends TaskResultData,
        PRECHECK, //
        EXECUTION_RESULT extends ExecutionUnitResult<PRECHECK>>
    extends ExecutionIntent {
  //
}

class TaskLoadInitIntent<
    TASK_INIT_DATA extends TaskInitData, //
    TASK_RESULT_DATA extends TaskResultData> extends TaskBaseExecutionIntent<
    TASK_INIT_DATA,
    TASK_RESULT_DATA, //
    TaskSubmitExcutionPrecheck,
    TaskSubmitExecutionResult> {
  final String lastIntentInfo;

  TaskLoadInitIntent({required this.lastIntentInfo});
}

class TaskSubmitIntent<
    TASK_INIT_DATA extends TaskInitData, //
    TASK_RESULT_DATA extends TaskResultData> extends TaskBaseExecutionIntent<
    TASK_INIT_DATA,
    TASK_RESULT_DATA, //
    TaskSubmitExcutionPrecheck,
    TaskSubmitExecutionResult> {
  final String lastIntentInfo;

  TaskSubmitIntent({required this.lastIntentInfo});
}

class TaskDoneIntent<
        TASK_INIT_DATA extends TaskInitData, TASK_RESULT_DATA extends TaskResultData>
    extends TaskBaseExecutionIntent<
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
