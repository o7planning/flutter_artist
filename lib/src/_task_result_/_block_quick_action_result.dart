part of '../_fa_core.dart';

class BlockQuickActionResult extends ActionResult<BlockQuickActionPrecheck> {
  BlockQuickActionResult({super.precheck, super.stackTrace});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return _appError == null;
  }
}
