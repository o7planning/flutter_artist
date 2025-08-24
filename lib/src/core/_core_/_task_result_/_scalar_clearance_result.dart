part of '../core.dart';

class ScalarClearanceResult extends TaskResult<ScalarClearancePrecheck> {
  ScalarClearanceResult({super.precheck});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return true;
  }
}
