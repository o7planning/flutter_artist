part of '../core.dart';

class FormSaveResult extends TaskResult<BlockFormSavePrecheck> {
  FormSaveResult({required super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return errorInfo == null;
  }
}
