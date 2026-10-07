part of '../core.dart';

class ActivityResult extends ExecutionUnitResult<ActivityV1Precheck> {
  ActivityResult({super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return true;
  }
}
