part of '../core.dart';

class FormModelDataLoadResult extends TaskResult<FormModelDataLoadPrecheck> {
  FormModelDataLoadResult({super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return errorInfo == null;
  }
}
