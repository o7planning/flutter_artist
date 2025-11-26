part of '../core.dart';

@RenameAnnotation()
class BlockQuickItemCreationResult
    extends TaskResult<BlockQuickItemCreationPrecheck> {
  BlockQuickItemCreationResult({
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
