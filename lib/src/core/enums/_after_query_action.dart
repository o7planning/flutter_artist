import '_current_item_setting_type.dart';

enum AfterQueryAction {
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

  CurrentItemSettingType? toCurrentItemSettingType() {
    switch (this) {
      case AfterQueryAction.clearCurrentItem:
        return null;
      case AfterQueryAction.createNewItem:
        return null;
      case AfterQueryAction.setAnItemAsCurrentIfNeed:
        return CurrentItemSettingType.setAnItemAsCurrentIfNeed;
      case AfterQueryAction.setAnItemAsCurrent:
        return CurrentItemSettingType.setAnItemAsCurrent;
      case AfterQueryAction.setAnItemAsCurrentThenLoadForm:
        return CurrentItemSettingType.setAnItemAsCurrentThenLoadForm;
    }
  }
}
