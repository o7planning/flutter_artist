part of '../core.dart';

@RenameAnnotation()
class BlockQuickUpdateItemResult
    extends TaskResult<BlockQuickItemUpdatePrecheck> {
  BlockQuickUpdateItemResult({super.precheck, super.stackTrace});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
