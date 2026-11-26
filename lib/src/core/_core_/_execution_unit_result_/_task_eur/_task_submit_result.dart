part of '../../core.dart';

class TaskSubmitResult<
TASK_INIT_DATA extends TaskInitData, //
TASK_RESULT_DATA extends TaskResultData>
    extends ExecutionUnitResult<TaskSubmitPrecheck> {
  TaskSubmitResult({required super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return errorInfo == null;
  }
}
