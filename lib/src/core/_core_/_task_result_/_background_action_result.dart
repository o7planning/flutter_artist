part of '../core.dart';

class BackgroundActionResult extends TaskResult<BackgroundActionPrecheck> {
  BackgroundActionResult({super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
