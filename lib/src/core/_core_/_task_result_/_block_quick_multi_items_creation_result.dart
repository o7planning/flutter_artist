part of '../core.dart';

@RenameAnnotation()
class BlockQuickMultiItemsCreationResult
    extends TaskResult<BlockMultiItemsCreationPrecheck> {
  BlockQuickMultiItemsCreationResult({super.precheck, super.stackTrace});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
