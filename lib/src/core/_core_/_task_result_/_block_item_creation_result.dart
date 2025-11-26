part of '../core.dart';

@RenameAnnotation()
class PrepareItemCreationResult extends TaskResult<BlockItemCreationPrecheck> {
  PrepareItemCreationResult({
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
