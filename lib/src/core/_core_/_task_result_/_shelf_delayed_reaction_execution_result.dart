part of '../core.dart';

class ShelfDelayedReactionExecutionResult
    extends TaskResult<ShelfDelayedReactionExecutionPrecheck> {
  ShelfDelayedReactionExecutionResult({super.precheck, super.stackTrace});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
