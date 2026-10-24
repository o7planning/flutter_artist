part of '../../core.dart';

class TaskSubmitExecutionResult<
        TASK_INIT_DATA extends TaskInitData, //
        TASK_RESULT_DATA extends TaskResultData>
    extends ExecutionUnitResult<TaskSubmitPrecheck> {
  TaskSubmitExecutionResult({required super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return errorInfo == null;
  }
}
