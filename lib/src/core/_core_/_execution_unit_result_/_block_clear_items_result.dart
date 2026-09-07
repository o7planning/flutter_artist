part of '../core.dart';

class BlockClearItemsResult
    extends ExecutionUnitResult<BlockClearItemsPrecheck> {
  BlockClearItemsResult({super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return true;
  }
}
