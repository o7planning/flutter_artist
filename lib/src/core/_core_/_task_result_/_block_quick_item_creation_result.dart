part of '../core.dart';

@RenameAnnotation()
class BlockQuickItemCreationResult
    extends TaskResult<BlockQuickItemCreationPrecheck> {
  BlockQuickItemCreationResult({super.precheck, super.stackTrace});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
