part of '../core.dart';

class BlockBackendActionResult
    extends ExecutionUnitResult<BlockBackendActionPrecheck> {
  BlockBackendActionResult({
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
