part of '../_fa_core.dart';

class BlockClearanceResult extends TaskResult<BlockClearancePrecheck> {
  BlockClearanceResult({super.precheck});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return true;
  }
}
