part of '../core.dart';

class StorageSilentActionResult
    extends TaskResult<StorageSilentActionPrecheck> {
  StorageSilentActionResult({super.precheck, super.stackTrace});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
