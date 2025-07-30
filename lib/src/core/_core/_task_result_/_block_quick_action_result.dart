part of '../code.dart';

class BlockQuickActionResult extends TaskResult<BlockQuickActionPrecheck> {
  BlockQuickActionResult({super.precheck, super.stackTrace});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return _appError == null;
  }
}
