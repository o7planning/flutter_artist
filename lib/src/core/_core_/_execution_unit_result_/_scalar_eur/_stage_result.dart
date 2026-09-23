part of '../../core.dart';

class StageSubmitResult extends ExecutionUnitResult<StageSubmitPrecheck> {
  StageSubmitResult({required super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return errorInfo == null;
  }
}
