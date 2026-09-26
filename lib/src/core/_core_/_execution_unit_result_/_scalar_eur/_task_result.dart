part of '../../core.dart';

class TaskSubmitExecutionResult<TASK_RESULT_DATA extends TaskResultData>
    extends ExecutionUnitResult<TaskSubmitExcutionPrecheck> {
  TaskSubmitExecutionResult({required super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return errorInfo == null;
  }
}
