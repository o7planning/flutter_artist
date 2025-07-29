part of '../_fa_core.dart';

@RenameAnnotation()
class BlockQuickCreateItemResult
    extends ActionResult<BlockQuickCreateItemPrecheck> {
  BlockQuickCreateItemResult({super.precheck, super.stackTrace});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
