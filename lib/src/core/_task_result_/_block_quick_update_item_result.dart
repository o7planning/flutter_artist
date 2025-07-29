part of '../_fa_core.dart';

@RenameAnnotation()
class BlockQuickUpdateItemResult
    extends TaskResult<BlockQuickUpdateItemPrecheck> {
  BlockQuickUpdateItemResult({super.precheck, super.stackTrace});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
