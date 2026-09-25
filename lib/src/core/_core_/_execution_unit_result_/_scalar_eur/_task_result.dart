part of '../../core.dart';

class TaskExecutionResult<TASK_DATA extends TaskData>
    extends ExecutionUnitResult<TaskExecutionPrecheck> {
  TaskExecutionResult({required super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return errorInfo == null;
  }
}
