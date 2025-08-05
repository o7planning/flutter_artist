part of '../core.dart';

@RenameAnnotation()
class BlockQuickMultiItemsCreationResult
    extends TaskResult<BlockMultiItemsCreationPrecheck> {
  BlockQuickMultiItemsCreationResult({super.precheck, super.stackTrace});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
