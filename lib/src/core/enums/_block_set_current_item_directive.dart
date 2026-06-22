enum BlockSetCurrentItemDirective {
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
