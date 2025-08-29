part of '../core.dart';

class ScalarSilentActionResult extends TaskResult<ScalarSilentActionPrecheck> {
  ScalarSilentActionResult({super.precheck, super.stackTrace});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
