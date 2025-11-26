part of '../core.dart';

class StorageSilentActionResult
    extends TaskResult<StorageSilentActionPrecheck> {
  StorageSilentActionResult({
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
