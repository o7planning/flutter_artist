part of '../core.dart';

@RenameAnnotation()
class BlockQuickItemUpdateResult
    extends TaskResult<BlockQuickItemUpdatePrecheck> {
  BlockQuickItemUpdateResult({super.precheck, super.stackTrace});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
