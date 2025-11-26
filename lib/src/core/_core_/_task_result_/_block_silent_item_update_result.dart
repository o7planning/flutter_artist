part of '../core.dart';

@RenameAnnotation()
class BlockSilentItemUpdateResult
    extends TaskResult<BlockSilentItemUpdatePrecheck> {
  BlockSilentItemUpdateResult({
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
