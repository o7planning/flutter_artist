part of '../core.dart';

@RenameAnnotation()
class BlockQuickItemCreationResult
    extends TaskResult<BlockQuickItemCreationPrecheck> {
  BlockQuickItemCreationResult({super.precheck, super.stackTrace});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
