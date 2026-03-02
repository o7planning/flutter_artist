part of '../core.dart';

class ShelfDeferredEventExecutionResult
    extends TaskResult<ShelfDeferredEventExecutionPrecheck> {
  ShelfDeferredEventExecutionResult({
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
