part of '../core.dart';

@RenameAnnotation()
class BlockSilentItemUpdateResult
    extends TaskResult<BlockSilentItemUpdatePrecheck> {
  BlockSilentItemUpdateResult({super.precheck, super.stackTrace});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
