part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for multi-item block deletion.
class BlockItemsDeletionPrecheckUtils {
  /// Evaluates whether a list of items can be deleted from a block.
  static Actionable<BlockItemsDeletionPrecheck> checkBeforeDeleteItems<ITEM>({
    required bool checkBusy,
    required bool isBusy,
    required bool checkAllow,
    required List<ITEM> items,
    required bool errorIfItemNotInTheBlock,
    required ITEM? Function(ITEM targetItem) findItemSameIdWith,
    required CheckAllowResult Function(ITEM validItem)
        checkItemsDeletionAllowed,
  }) {
    // 1. Check if the system is busy
    if (checkBusy && isBusy) {
      return Actionable<BlockItemsDeletionPrecheck>.no(
        errCode: BlockItemsDeletionPrecheck.busy,
      );
    }

    // 2. Check if the list is empty
    if (items.isEmpty) {
      return Actionable<BlockItemsDeletionPrecheck>.no(
        errCode: BlockItemsDeletionPrecheck.noTarget,
      );
    }

    // 3. Validate items against the block and individual permissions
    for (final ITEM item in items) {
      // Check if the item belongs to the block
      if (errorIfItemNotInTheBlock) {
        final ITEM? foundItem = findItemSameIdWith(item);
        if (foundItem == null) {
          return Actionable<BlockItemsDeletionPrecheck>.no(
            errCode: BlockItemsDeletionPrecheck.invalidTarget,
          );
        }
      }

      // Check business permission rules for the item
      if (checkAllow) {
        final CheckAllowResult result = checkItemsDeletionAllowed(item);
        switch (result.result) {
          case CheckAllow.allow:
            break; // Continue checking next items
          case CheckAllow.notAllow:
            return Actionable<BlockItemsDeletionPrecheck>.no(
              errCode: BlockItemsDeletionPrecheck.notAllow,
            );
          case CheckAllow.error:
            return Actionable<BlockItemsDeletionPrecheck>.no(
              errCode: BlockItemsDeletionPrecheck.checkAllowMethodError,
              errorInfo: result.errorInfo,
            );
        }
      }
    }
    return Actionable<BlockItemsDeletionPrecheck>.yes();
  }
}
