enum CurrentItemSelectionType {
  doNothing,
  selectAnItemAsCurrentIfNeed, // DEFAULT.
  selectAnItemAsCurrent,
  selectAnItemAsCurrentAndLoadForm,
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
