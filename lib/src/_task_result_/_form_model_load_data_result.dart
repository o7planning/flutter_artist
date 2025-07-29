part of '../_fa_core.dart';

@RenameAnnotation("FormModelDataLoadResult")
class FormModelLoadDataResult extends ActionResult<FormModelLoadDataPrecheck> {
  FormModelLoadDataResult({super.precheck});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
