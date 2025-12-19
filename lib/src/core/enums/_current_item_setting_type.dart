enum CurrentItemSettingType {
  setAnItemAsCurrentIfNeed, // DEFAULT.
  setAnItemAsCurrent,
  setAnItemAsCurrentThenLoadForm,
  refresh;
}

enum CurrentItemSelInclusion {
  withoutCurrentItem,
  withCurrentIfSelected,
  withCurrentItem;
}

enum CurrentItemChkInclusion {
  withoutCurrentItem,
  withCurrentIfChecked,
  withCurrentItem;
}
