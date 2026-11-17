part of '../../core.dart';

class ScalarClearValueResult
    extends ExecutionUnitResult<ScalarClearValuePrecheck> {
  ScalarClearValueResult({super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return true;
  }
}
