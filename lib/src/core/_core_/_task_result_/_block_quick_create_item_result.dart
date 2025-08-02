part of '../core.dart';

@RenameAnnotation()
class BlockQuickCreateItemResult
    extends TaskResult<BlockQuickItemCreationPrecheck> {
  BlockQuickCreateItemResult({super.precheck, super.stackTrace});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
