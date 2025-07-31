part of '../core.dart';

class ScalarQuickActionResult extends TaskResult<ScalarQuickActionPrecheck> {
  ScalarQuickActionResult({super.precheck, super.stackTrace});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
