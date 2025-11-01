enum CurrentItemSelectionType {
  doNothing,
  setAnItemAsCurrentIfNeed, // DEFAULT.
  setAnItemAsCurrent,
  setAnItemAsCurrentAndLoadForm,
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
