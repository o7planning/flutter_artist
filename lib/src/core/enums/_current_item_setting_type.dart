enum CurrentItemSettingType {
  setAnItemAsCurrentIfNeed, // DEFAULT.
  setAnItemAsCurrent,
  setAnItemAsCurrentThenLoadForm,
  refresh;
}

enum CurrentItemInclusion {
  exclude,
  ifMatch,
  include,
}

// enum CurrentItemSelInclusion {
//   withoutCurrentItem,
//   withCurrentIfSelected,
//   withCurrentItem;
// }

// enum CurrentItemChkInclusion {
//   withoutCurrentItem,
//   withCurrentIfChecked,
//   withCurrentItem;
// }
