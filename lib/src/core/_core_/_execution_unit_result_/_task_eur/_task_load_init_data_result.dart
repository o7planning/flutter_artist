part of '../../core.dart';

class TaskLoadInitDataResult<
        INIT_DATA extends TaskInitData >
    extends ExecutionUnitResult<TaskLoadInitDataPrecheck> {
  TaskLoadInitDataResult({required super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return errorInfo == null;
  }
}
