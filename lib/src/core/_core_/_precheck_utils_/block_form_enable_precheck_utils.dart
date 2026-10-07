part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for block form enable operations.
class BlockFormEnablePrecheckUtils {
  /// Evaluates whether the block form is permitted to be enabled.
  static Actionable<BlockFormEnablePrecheck> checkFormEnable<ITEM>({
    required bool hasForm,
    required bool isStateReadyForForm,
    required FormDataState? formDataState,
    required ITEM? currentItem,
    required bool checkAllow,
    required CheckAllowResult Function(ITEM validItem) checkItemUpdateAllowed,
  }) {
    // 1. Check if form model exists
    if (!hasForm) {
      return Actionable<BlockFormEnablePrecheck>.no(
        errCode: BlockFormEnablePrecheck.noForm,
      );
    }

    // 2. Check if block state is ready for form
    if (!isStateReadyForForm) {
      return Actionable<BlockFormEnablePrecheck>.no(
        errCode: BlockFormEnablePrecheck.hostStateNotReadyForForm,
      );
    }

    // 3. Check FormDataState constraints
    if (formDataState == null) {
      return Actionable<BlockFormEnablePrecheck>.no(
        errCode: BlockFormEnablePrecheck.noForm,
      );
    }

    if (formDataState.isNone) {
      return Actionable<BlockFormEnablePrecheck>.no(
        errCode: BlockFormEnablePrecheck.formInNoneState,
      );
    } else if (formDataState.isPending) {
      return Actionable<BlockFormEnablePrecheck>.no(
        errCode: BlockFormEnablePrecheck.formInPendingState,
      );
    } else if (formDataState.isFatalError) {
      return Actionable<BlockFormEnablePrecheck>.no(
        errCode: BlockFormEnablePrecheck.formInFatalErrorState,
      );
    } else if (formDataState.isStale) {
      return Actionable<BlockFormEnablePrecheck>.no(
        errCode: BlockFormEnablePrecheck.formInStaleState,
      );
    }

    // 4. Check business permission rules if currentItem exists
    if (checkAllow && currentItem != null) {
      final CheckAllowResult result = checkItemUpdateAllowed(currentItem);
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockFormEnablePrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockFormEnablePrecheck>.no(
            errCode: BlockFormEnablePrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockFormEnablePrecheck>.no(
            errCode: BlockFormEnablePrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }

    return Actionable<BlockFormEnablePrecheck>.yes();
  }
}
