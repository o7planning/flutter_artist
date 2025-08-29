part of '../core.dart';

class BlockSilentActionResult extends TaskResult<BlockSilentActionPrecheck> {
  BlockSilentActionResult({super.precheck, super.stackTrace});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
