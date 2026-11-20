part of '../core.dart';

class StorageBackendActionResult
    extends ExecutionUnitResult<StorageBackendActionPrecheck> {
  StorageBackendActionResult({
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
