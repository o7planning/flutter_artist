part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for block quick item creation operations.
class BlockQuickItemCreationPrecheckUtils {
  /// Evaluates whether quick creating an item is permitted based on system busy state,
  /// block data states, and business permission rules.
  static Actionable<BlockQuickItemCreationPrecheck> checkBeforeQuickCreateItem({
    required bool checkBusy,
    required bool isBusy,
    required BlockDataState blockDataState,
    required bool checkAllow,
    required CheckAllowResult Function() checkQuickCreateAllowed,
  }) {
    // 1. Priority 1: Check if the system executor is busy
    if (checkBusy && isBusy) {
      return Actionable<BlockQuickItemCreationPrecheck>.no(
        errCode: BlockQuickItemCreationPrecheck.busy,
      );
    }

    // 2. Priority 2: Check Block DataState constraints
    switch (blockDataState) {
      case BlockDataStateNone():
        return Actionable<BlockQuickItemCreationPrecheck>.no(
          errCode: BlockQuickItemCreationPrecheck.blockInNoneState,
        );
      case BlockDataStatePending():
        return Actionable<BlockQuickItemCreationPrecheck>.no(
          errCode: BlockQuickItemCreationPrecheck.blockInPendingState,
        );
      case BlockDataStateLoadedStale():
        return Actionable<BlockQuickItemCreationPrecheck>.no(
          errCode: BlockQuickItemCreationPrecheck.blockInStaleState,
        );
      case BlockDataStateLoadedFresh():
        break;
    }

    // 3. Priority 3: Check business permission rules
    if (checkAllow) {
      final CheckAllowResult result = checkQuickCreateAllowed();
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockQuickItemCreationPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockQuickItemCreationPrecheck>.no(
            errCode: BlockQuickItemCreationPrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockQuickItemCreationPrecheck>.no(
            errCode: BlockQuickItemCreationPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }

    return Actionable<BlockQuickItemCreationPrecheck>.yes();
  }
}
