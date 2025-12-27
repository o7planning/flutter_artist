part of '../core.dart';

class FormModelEnterFormFieldsResult
    extends TaskResult<EnterFormFieldsPrecheck> {
  FormModelEnterFormFieldsResult({super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return errorInfo == null;
  }
}
