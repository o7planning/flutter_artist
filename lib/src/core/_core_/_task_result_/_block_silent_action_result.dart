part of '../core.dart';

class BlockSilentActionResult extends TaskResult<BlockSilentActionPrecheck> {
  BlockSilentActionResult({
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
