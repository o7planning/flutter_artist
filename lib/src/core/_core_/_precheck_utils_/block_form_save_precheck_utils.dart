part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for block form save operations.
class BlockFormSavePrecheckUtils {
  /// Evaluates whether saving a block's form is permitted.
  static Actionable<BlockFormSavePrecheck> checkBeforeSaveForm({
    required bool checkBusy,
    required bool isBusy,
    required bool hasForm,
    required FormDataState? formDataState,
    required bool isDirty,
    required bool checkValidate,
    required List<dynamic> Function()? getActiveFormStates,
  }) {
    // 1. Priority 1: Check if the system executor is busy
    if (checkBusy && isBusy) {
      return Actionable<BlockFormSavePrecheck>.no(
        errCode: BlockFormSavePrecheck.busy,
      );
    }

    // 2. Priority 2: Check if form model exists
    if (!hasForm || formDataState == null) {
      return Actionable<BlockFormSavePrecheck>.no(
        errCode: BlockFormSavePrecheck.noForm,
      );
    }

    // 3. Priority 3: Check if form is dirty (has modifications)
    if (!isDirty) {
      return Actionable<BlockFormSavePrecheck>.no(
        errCode: BlockFormSavePrecheck.formIsNotDirty,
      );
    }

    // 4. Priority 4: Check FormDataState constraints
    if (formDataState.isNone) {
      return Actionable<BlockFormSavePrecheck>.no(
        errCode: BlockFormSavePrecheck.formInNoneState,
      );
    } else if (formDataState.isPending) {
      return Actionable<BlockFormSavePrecheck>.no(
        errCode: BlockFormSavePrecheck.formInPendingState,
      );
    } else if (formDataState.isFatalError) {
      return Actionable<BlockFormSavePrecheck>.no(
        errCode: BlockFormSavePrecheck.formInFatalErrorState,
      );
    } else if (formDataState.isStale) {
      return Actionable<BlockFormSavePrecheck>.no(
        errCode: BlockFormSavePrecheck.formInStaleState,
      );
    }

    // 5. Priority 5: Validate active form fields if requested
    if (checkValidate && getActiveFormStates != null) {
      final List<dynamic> activeForms = getActiveFormStates();
      bool allFormsAreValid = true;

      if (activeForms.isNotEmpty) {
        for (final formState in activeForms) {
          bool isValid = formState.validate(focusOnInvalid: false);
          allFormsAreValid = allFormsAreValid && isValid;
        }
      }

      if (!allFormsAreValid) {
        return Actionable<BlockFormSavePrecheck>.no(
          errCode: BlockFormSavePrecheck.formInvalidated,
        );
      }
    }

    return Actionable<BlockFormSavePrecheck>.yes();
  }
}
