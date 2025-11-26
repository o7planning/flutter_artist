part of '../core.dart';

@RenameAnnotation()
class BlockQuickItemUpdateResult
    extends TaskResult<BlockQuickItemUpdatePrecheck> {
  BlockQuickItemUpdateResult({
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
