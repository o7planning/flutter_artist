part of '../core.dart';

class BackgroundActionResult extends TaskResult<BackgroundActionPrecheck> {
  BackgroundActionResult({super.precheck});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
