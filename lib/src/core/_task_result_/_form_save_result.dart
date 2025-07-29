part of '../_fa_core.dart';

class FormSaveResult extends TaskResult<BlockFormSavePrecheck> {
  FormSaveResult({required super.precheck});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return error == null;
  }
}
