part of '../core.dart';

@RenameAnnotation("FormModelDataLoadResult")
class FormModelLoadDataResult extends TaskResult<FormModelDataLoadPrecheck> {
  FormModelLoadDataResult({super.precheck});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
