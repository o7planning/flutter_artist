// TODO-XXX Change to PostQueryAction?

import '_current_item_selection_type.dart';

enum PostQueryBehavior {
  /// Do Nothing.
  doNothing,

  /// Clear Current Item.
  clearCurrentItem,

  /// Create new Item.
  createNewItem,

  /// Default behavior.
  selectAnItemAsCurrentIfNeed,

  /// Select an available item in the List or switch to non-selected if List is empty.
  selectAnItemAsCurrent,

  /// Select an available item in the List and prepare form to edit.
  selectAnItemAsCurrentAndLoadForm;

  CurrentItemSelectionType toCurrentItemSelectionType() {
    switch (this) {
      case PostQueryBehavior.doNothing:
        return CurrentItemSelectionType.doNothing;
      case PostQueryBehavior.clearCurrentItem:
        return CurrentItemSelectionType.doNothing;
      case PostQueryBehavior.createNewItem:
        return CurrentItemSelectionType.doNothing;
      case PostQueryBehavior.selectAnItemAsCurrentIfNeed:
        return CurrentItemSelectionType.selectAnItemAsCurrentIfNeed;
      case PostQueryBehavior.selectAnItemAsCurrent:
        return CurrentItemSelectionType.selectAnItemAsCurrent;
      case PostQueryBehavior.selectAnItemAsCurrentAndLoadForm:
        return CurrentItemSelectionType.selectAnItemAsCurrentAndLoadForm;
    }
  }
}
