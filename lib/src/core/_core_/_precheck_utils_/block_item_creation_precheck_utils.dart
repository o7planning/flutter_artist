part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for block item creation operations via form.
class BlockItemCreationPrecheckUtils {
  /// Evaluates whether creating a new item on form is permitted.
  static Actionable<BlockItemCreationPrecheck> checkBeforeCreateItemOnForm({
    required bool checkBusy,
    required bool isBusy,
    required bool hasForm,
    required BlockDataState blockDataState,
    required bool checkAllow,
    required CheckAllowResult Function() checkCreationAllowed,
  }) {
    // 1. Priority 1: Check if the system executor is busy
    if (checkBusy && isBusy) {
      return Actionable<BlockItemCreationPrecheck>.no(
        errCode: BlockItemCreationPrecheck.busy,
      );
    }

    // 2. Priority 2: Check if form model exists (Since this is specifically for Form creation)
    if (!hasForm) {
      return Actionable<BlockItemCreationPrecheck>.no(
        errCode: BlockItemCreationPrecheck.noForm,
      );
    }

    // 3. Priority 3: Check Block DataState constraints
    switch (blockDataState) {
      case BlockDataStateNone():
        return Actionable<BlockItemCreationPrecheck>.no(
          errCode: BlockItemCreationPrecheck.blockInNoneState,
        );
      case BlockDataStatePending():
        return Actionable<BlockItemCreationPrecheck>.no(
          errCode: BlockItemCreationPrecheck.blockInPendingState,
        );
      case BlockDataStateLoadedStale():
        return Actionable<BlockItemCreationPrecheck>.no(
          errCode: BlockItemCreationPrecheck.blockInStaleState,
        );
      case BlockDataStateLoadedFresh():
        break;
    }

    // 4. Priority 4: Check business permission rules
    if (checkAllow) {
      final CheckAllowResult result = checkCreationAllowed();
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockItemCreationPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockItemCreationPrecheck>.no(
            errCode: BlockItemCreationPrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockItemCreationPrecheck>.no(
            errCode: BlockItemCreationPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }

    return Actionable<BlockItemCreationPrecheck>.yes();
  }
}
