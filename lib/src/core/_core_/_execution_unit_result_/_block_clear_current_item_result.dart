part of '../core.dart';

class BlockClearCurrentItemResult
    extends ExecutionUnitResult<BlockClearCurrentItemPrecheck> {
  BlockClearCurrentItemResult({super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return true;
  }
}
