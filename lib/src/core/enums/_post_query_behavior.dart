// TODO-XXX Change to PostQueryAction?

import '_current_item_selection_type.dart';

enum PostQueryBehavior {
  /// Do Nothing.
  doNothing,

  /// Clear Current Item.
  clearCurrentItem,

  /// Create new Item.
  @Deprecated("Xoa di?")
  createNewItem,

  /// Default behavior.
  setAnItemAsCurrentIfNeed,

  /// Select an available item in the List or switch to non-selected if List is empty.
  setAnItemAsCurrent,

  /// Select an available item in the List and prepare form to edit.
  setAnItemAsCurrentThenLoadForm;

  CurrentItemSelectionType toCurrentItemSelectionType() {
    switch (this) {
      case PostQueryBehavior.doNothing:
        return CurrentItemSelectionType.doNothing;
      case PostQueryBehavior.clearCurrentItem:
        return CurrentItemSelectionType.doNothing;
      case PostQueryBehavior.createNewItem:
        return CurrentItemSelectionType.doNothing;
      case PostQueryBehavior.setAnItemAsCurrentIfNeed:
        return CurrentItemSelectionType.selectAnItemAsCurrentIfNeed;
      case PostQueryBehavior.setAnItemAsCurrent:
        return CurrentItemSelectionType.selectAnItemAsCurrent;
      case PostQueryBehavior.setAnItemAsCurrentThenLoadForm:
        return CurrentItemSelectionType.selectAnItemAsCurrentAndLoadForm;
    }
  }
}
