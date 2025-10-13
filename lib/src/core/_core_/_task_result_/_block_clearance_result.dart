part of '../core.dart';

class BlockClearanceResult extends TaskResult<BlockClearancePrecheck> {
  BlockClearanceResult({super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return true;
  }
}
