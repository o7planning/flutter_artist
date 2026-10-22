part of '../../core.dart';

class TaskRestartResult<
        INIT_DATA extends TaskInitData, //
        RESULT_DATA extends TaskResultData>
    extends ExecutionUnitResult<TaskRestartPrecheck> {
  TaskRestartResult({required super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return errorInfo == null;
  }
}
