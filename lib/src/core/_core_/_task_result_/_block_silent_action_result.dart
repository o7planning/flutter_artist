part of '../core.dart';

class BlockSilentActionResult extends TaskResult<BlockSilentActionPrecheck> {
  BlockSilentActionResult({super.precheck, super.stackTrace});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
