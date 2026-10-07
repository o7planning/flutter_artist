part of '../core.dart';

class AppBackendActionResult
    extends ExecutionUnitResult<AppBackendActionPrecheck> {
  AppBackendActionResult({
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
