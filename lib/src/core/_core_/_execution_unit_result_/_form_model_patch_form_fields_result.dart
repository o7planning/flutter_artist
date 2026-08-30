part of '../core.dart';

class FormModelPatchFormFieldsResult
    extends ExecutionUnitResult<PatchFormFieldsPrecheck> {
  FormModelPatchFormFieldsResult({super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return errorInfo == null;
  }
}
