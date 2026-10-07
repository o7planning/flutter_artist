part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for block form reset operations.
class BlockFormResetPrecheckUtils {
  /// Evaluates whether resetting a block's form is permitted.
  static Actionable<BlockFormResetPrecheck> checkBeforeResetForm({
    required bool checkBusy,
    required bool isBusy,
    required bool hasForm,
    required FormDataState? formDataState,
    required bool isDirty,
    required bool checkAllow,
    required CheckAllowResult Function() checkFormResetAllowed,
  }) {
    // 1. Priority 1: Check if the system executor is busy
    if (checkBusy && isBusy) {
      return Actionable<BlockFormResetPrecheck>.no(
        errCode: BlockFormResetPrecheck.busy,
      );
    }

    // 2. Priority 2: Check if form model exists
    if (!hasForm || formDataState == null) {
      return Actionable<BlockFormResetPrecheck>.no(
        errCode: BlockFormResetPrecheck.noForm,
      );
    }

    // 3. Priority 3: Check FormDataState constraints
    if (formDataState.isNone) {
      return Actionable<BlockFormResetPrecheck>.no(
        errCode: BlockFormResetPrecheck.formInNoneState,
      );
    } else if (formDataState.isPending) {
      return Actionable<BlockFormResetPrecheck>.no(
        errCode: BlockFormResetPrecheck.formInPendingState,
      );
    } else if (formDataState.isFatalError) {
      return Actionable<BlockFormResetPrecheck>.no(
        errCode: BlockFormResetPrecheck.formInFatalErrorState,
      );
    } else if (formDataState.isStale) {
      return Actionable<BlockFormResetPrecheck>.no(
        errCode: BlockFormResetPrecheck.formInStaleState,
      );
    }

    // 4. Priority 4: Check if form is dirty (has changes to reset)
    if (!isDirty) {
      return Actionable<BlockFormResetPrecheck>.no(
        errCode: BlockFormResetPrecheck.formIsNotDirty,
      );
    }

    // 5. Priority 5: Check business permission rules
    if (checkAllow) {
      final CheckAllowResult result = checkFormResetAllowed();
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockFormResetPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockFormResetPrecheck>.no(
            errCode: BlockFormResetPrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockFormResetPrecheck>.no(
            errCode: BlockFormResetPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }

    return Actionable<BlockFormResetPrecheck>.yes();
  }
}
