part of '../core.dart';

class FormModelDataLoadResult
    extends ExecutionUnitResult<FormModelDataLoadPrecheck> {
  FormModelDataLoadResult({super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return errorInfo == null;
  }
}
