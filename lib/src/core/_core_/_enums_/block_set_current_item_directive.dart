part of '_enums.dart';

enum BlockSetCurrentItemDirective {
  setAnItemAsCurrentIfNeed, // DEFAULT.
  setAnItemAsCurrent,
  setAnItemAsCurrentThenLoadForm,
}

enum CurrentItemInclusion {
  exclude,
  ifMatch,
  include,
}
