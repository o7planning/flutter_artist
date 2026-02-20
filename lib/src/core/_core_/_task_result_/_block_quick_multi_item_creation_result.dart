part of '../core.dart';

@RenameAnnotation()
class BlockQuickMultiItemCreationResult
    extends TaskResult<BlockQuickMultiItemCreationPrecheck> {
  BlockQuickMultiItemCreationResult({
    super.precheck,
    super.errorInfo,
  });

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return errorInfo == null;
  }
}
