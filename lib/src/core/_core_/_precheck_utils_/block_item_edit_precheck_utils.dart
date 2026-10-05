part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for block item editing operations.
class BlockItemEditPrecheckUtils {
  /// Evaluates whether an item is permitted to be edited on a form.
  static Actionable<BlockItemEditPrecheck> checkBeforeEditItem<ITEM>({
    required bool checkBusy,
    required bool isBusy,
    required bool hasForm,
    required BlockDataState blockDataState,
    required FormDataState? formDataState,
    required ITEM? item,
    required bool checkAllow,
    required CheckAllowResult Function(ITEM validItem) checkItemEditAllowed,
  }) {
    // 1. Check if the system is busy
    if (checkBusy && isBusy) {
      return Actionable<BlockItemEditPrecheck>.no(
        errCode: BlockItemEditPrecheck.busy,
      );
    }

    // 2. Check if form model exists
    if (!hasForm) {
      return Actionable<BlockItemEditPrecheck>.no(
        errCode: BlockItemEditPrecheck.noForm,
      );
    }

    // 3. Check if form is in fatal error state directly from FormDataState
    if (formDataState?.isFatalError ?? false) {
      return Actionable<BlockItemEditPrecheck>.no(
        errCode: BlockItemEditPrecheck.formInFatalErrorState,
      );
    }

    // 4. Check if target item exists
    if (item == null) {
      return Actionable<BlockItemEditPrecheck>.no(
        errCode: BlockItemEditPrecheck.noTarget,
      );
    }

    // 5. Check Block DataState constraints
    switch (blockDataState) {
      case BlockDataStateNone():
        return Actionable<BlockItemEditPrecheck>.no(
          errCode: BlockItemEditPrecheck.blockInNoneState,
        );
      case BlockDataStatePending():
        return Actionable<BlockItemEditPrecheck>.no(
          errCode: BlockItemEditPrecheck.blockInPendingState,
        );
      case BlockDataStateLoadedStale():
        return Actionable<BlockItemEditPrecheck>.no(
          errCode: BlockItemEditPrecheck.blockInStaleState,
        );
      case BlockDataStateLoadedFresh():
        break;
    }

    // 6. Check business permission rules
    if (checkAllow) {
      final CheckAllowResult result = checkItemEditAllowed(item);
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockItemEditPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockItemEditPrecheck>.no(
            errCode: BlockItemEditPrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockItemEditPrecheck>.no(
            errCode: BlockItemEditPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }

    return Actionable<BlockItemEditPrecheck>.yes();
  }
}
