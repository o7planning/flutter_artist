part of '../core.dart';

class ScalarClearanceResult extends TaskResult<ScalarClearancePrecheck> {
  ScalarClearanceResult({super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return true;
  }
}
