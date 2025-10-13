part of '../core.dart';

@RenameAnnotation()
class BlockSilentItemUpdateResult
    extends TaskResult<BlockSilentItemUpdatePrecheck> {
  BlockSilentItemUpdateResult({super.precheck, super.stackTrace});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
