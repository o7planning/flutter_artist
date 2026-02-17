part of '../core.dart';

@RenameAnnotation()
class BlockBulkItemsCreationResult
    extends TaskResult<BlockBulkItemsCreationPrecheck> {
  BlockBulkItemsCreationResult({
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
