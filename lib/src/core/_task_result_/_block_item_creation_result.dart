part of '../_fa_core.dart';

@RenameAnnotation()
class PrepareItemCreationResult extends TaskResult<BlockItemCreationPrecheck> {
  PrepareItemCreationResult({super.precheck, super.stackTrace});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
