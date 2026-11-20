part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for form model patch form fields operations.
class FormModelPatchFormFieldsPrecheckUtils {
  /// Evaluates whether patching form fields is permitted based on system busy state and form data states.
  static Actionable<FormModelPatchFormFieldsPrecheck>
      checkBeforePatchFormFields({
    required bool checkBusy,
    required bool isBusy,
    required FormDataState formDataState,
  }) {
    // 1. Priority 1: Check if the system executor is busy
    if (checkBusy && isBusy) {
      return Actionable<FormModelPatchFormFieldsPrecheck>.no(
        errCode: FormModelPatchFormFieldsPrecheck.busy,
      );
    }

    // 2. Priority 2: Check FormDataState constraints
    if (formDataState.isNone) {
      return Actionable<FormModelPatchFormFieldsPrecheck>.no(
        errCode: FormModelPatchFormFieldsPrecheck.formInNoneState,
      );
    }
    if (formDataState.isPending) {
      return Actionable<FormModelPatchFormFieldsPrecheck>.no(
        errCode: FormModelPatchFormFieldsPrecheck.formInPendingState,
      );
    }
    if (formDataState.isFatalError) {
      return Actionable<FormModelPatchFormFieldsPrecheck>.no(
        errCode: FormModelPatchFormFieldsPrecheck.formInFatalErrorState,
      );
    }

    return Actionable<FormModelPatchFormFieldsPrecheck>.yes();
  }
}
