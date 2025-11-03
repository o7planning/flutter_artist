import '_current_item_selection_type.dart';

enum AfterQueryAction {
  /// Do Nothing.
  doNothing,

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

  CurrentItemSelectionType toCurrentItemSelectionType() {
    switch (this) {
      case AfterQueryAction.doNothing:
        return CurrentItemSelectionType.doNothing;
      case AfterQueryAction.clearCurrentItem:
        return CurrentItemSelectionType.doNothing;
      case AfterQueryAction.createNewItem:
        return CurrentItemSelectionType.doNothing;
      case AfterQueryAction.setAnItemAsCurrentIfNeed:
        return CurrentItemSelectionType.setAnItemAsCurrentIfNeed;
      case AfterQueryAction.setAnItemAsCurrent:
        return CurrentItemSelectionType.setAnItemAsCurrent;
      case AfterQueryAction.setAnItemAsCurrentThenLoadForm:
        return CurrentItemSelectionType.setAnItemAsCurrentThenLoadForm;
    }
  }
}
