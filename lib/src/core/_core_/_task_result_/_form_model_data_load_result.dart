part of '../core.dart';

class FormModelDataLoadResult extends TaskResult<FormModelDataLoadPrecheck> {
  FormModelDataLoadResult({super.precheck});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
