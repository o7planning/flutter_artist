part of '../core.dart';

@RenameAnnotation()
class PrepareItemCreationResult extends TaskResult<BlockItemCreationPrecheck> {
  PrepareItemCreationResult({super.precheck, super.stackTrace});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
