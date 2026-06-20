import '_block_set_current_item_directive.dart';

enum BlockAfterQueryDirective {
  /// Clear Current Item.
  clearCurrentItem,

  /// Create new Item.
  createNewItem,

  /// Default behavior.
  setAnItemAsCurrentIfNeed,

  /// Select an available item in the List or switch to non-selected if List is empty.
  setAnItemAsCurrent,

  /// Select an available item in the List and prepare form to edit.
  setAnItemAsCurrentThenLoadForm;

  BlockSetCurrentItemDirective? toSetCurrentItemDirective() {
    switch (this) {
      case BlockAfterQueryDirective.clearCurrentItem:
        return null;
      case BlockAfterQueryDirective.createNewItem:
        return null;
      case BlockAfterQueryDirective.setAnItemAsCurrentIfNeed:
        return BlockSetCurrentItemDirective.setAnItemAsCurrentIfNeed;
      case BlockAfterQueryDirective.setAnItemAsCurrent:
        return BlockSetCurrentItemDirective.setAnItemAsCurrent;
      case BlockAfterQueryDirective.setAnItemAsCurrentThenLoadForm:
        return BlockSetCurrentItemDirective.setAnItemAsCurrentThenLoadForm;
    }
  }
}
