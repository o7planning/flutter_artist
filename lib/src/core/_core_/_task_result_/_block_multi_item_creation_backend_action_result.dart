part of '../core.dart';

@RenameAnnotation()
class BlockMultiItemCreationBackendActionResult
    extends TaskResult<BlockMultiItemCreationBackendActionPrecheck> {
  BlockMultiItemCreationBackendActionResult({
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
