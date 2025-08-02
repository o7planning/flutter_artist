part of '../core.dart';

@RenameAnnotation()
class BlockQuickCreateMultiItemsResult
    extends TaskResult<BlockMultiItemsCreationPrecheck> {
  BlockQuickCreateMultiItemsResult({super.precheck, super.stackTrace});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
