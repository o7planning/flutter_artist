part of '../core.dart';

class ShelfQueuedEventExecutionResult
    extends TaskResult<ShelfQueuedEventExecutionPrecheck> {
  ShelfQueuedEventExecutionResult({
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
