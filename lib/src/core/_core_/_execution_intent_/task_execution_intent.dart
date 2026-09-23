part of '../core.dart';

sealed class TaskBaseExecutionIntent<
        TASK_DATA extends TaskData, //
        PRECHECK, //
        EXECUTION_RESULT extends ExecutionUnitResult<PRECHECK>>
    extends ExecutionIntent {
  //
}

class TaskExecutionIntent<TASK_DATA extends TaskData>
    extends TaskBaseExecutionIntent<
        TASK_DATA, //
        TaskExecutionPrecheck,
        TaskExecutionResult> {
  final String lastIntentInfo;

  TaskExecutionIntent({required this.lastIntentInfo});
}

class TaskDoneIntent<TASK_DATA extends TaskData>
    extends TaskBaseExecutionIntent<
        TASK_DATA, //
        TaskExecutionPrecheck,
        TaskExecutionResult> {
  final String lastIntentInfo;

  TaskDoneIntent({required this.lastIntentInfo});
}

class TaskNullIntent<TASK_DATA extends TaskData>
    extends TaskBaseExecutionIntent<
        TASK_DATA, //
        TaskExecutionPrecheck,
        TaskExecutionResult> {
  final String lastIntentInfo;

  TaskNullIntent({required this.lastIntentInfo});
}
