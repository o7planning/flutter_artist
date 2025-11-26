part of '../core.dart';

@RenameAnnotation()
class BlockSilentItemCreationResult
    extends TaskResult<BlockSilentItemCreationPrecheck> {
  BlockSilentItemCreationResult({
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
