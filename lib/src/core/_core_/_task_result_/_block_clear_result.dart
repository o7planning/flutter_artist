part of '../core.dart';

class BlockClearResult extends TaskResult<BlockClearPrecheck> {
  BlockClearResult({super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return true;
  }
}
