part of '../core.dart';

class ScalarClearResult extends TaskResult<ScalarClearPrecheck> {
  ScalarClearResult({super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return true;
  }
}
