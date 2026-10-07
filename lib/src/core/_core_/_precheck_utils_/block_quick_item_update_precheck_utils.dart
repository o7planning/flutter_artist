part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for block quick item update operations.
class BlockQuickItemUpdatePrecheckUtils {
  /// Evaluates whether quick updating an item is permitted.
  static Actionable<BlockQuickItemUpdatePrecheck>
      checkBeforeQuickUpdateItem<ITEM>({
    required bool checkBusy,
    required bool isBusy,
    required BlockDataState blockDataState,
    required ITEM? item,
    required bool Function(ITEM targetItem) containsItem,
    required bool checkAllow,
    required CheckAllowResult Function(ITEM validItem) checkQuickUpdateAllowed,
  }) {
    // 1. Priority 1: Check if the system executor is busy
    if (checkBusy && isBusy) {
      return Actionable<BlockQuickItemUpdatePrecheck>.no(
        errCode: BlockQuickItemUpdatePrecheck.busy,
      );
    }

    // 2. Priority 2: Check Block DataState constraints
    switch (blockDataState) {
      case BlockDataStateNone():
        return Actionable<BlockQuickItemUpdatePrecheck>.no(
          errCode: BlockQuickItemUpdatePrecheck.blockInNoneState,
        );
      case BlockDataStatePending():
        return Actionable<BlockQuickItemUpdatePrecheck>.no(
          errCode: BlockQuickItemUpdatePrecheck.blockInPendingState,
        );
      case BlockDataStateLoadedStale():
        return Actionable<BlockQuickItemUpdatePrecheck>.no(
          errCode: BlockQuickItemUpdatePrecheck.blockInStaleState,
        );
      case BlockDataStateLoadedFresh():
        break;
    }

    // 3. Priority 3: Check target item existence
    if (item == null) {
      return Actionable<BlockQuickItemUpdatePrecheck>.no(
        errCode: BlockQuickItemUpdatePrecheck.noTarget,
      );
    }

    // 4. Priority 4: Check if item exists in the list
    if (!containsItem(item)) {
      return Actionable<BlockQuickItemUpdatePrecheck>.no(
        errCode: BlockQuickItemUpdatePrecheck.invalidTarget,
      );
    }

    // 5. Priority 5: Check business permission rules
    if (checkAllow) {
      final CheckAllowResult result = checkQuickUpdateAllowed(item);
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockQuickItemUpdatePrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockQuickItemUpdatePrecheck>.no(
            errCode: BlockQuickItemUpdatePrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockQuickItemUpdatePrecheck>.no(
            errCode: BlockQuickItemUpdatePrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }

    return Actionable<BlockQuickItemUpdatePrecheck>.yes();
  }
}
