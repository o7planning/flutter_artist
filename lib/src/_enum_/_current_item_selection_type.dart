part of '../../flutter_artist.dart';

enum CurrentItemSelectionType {
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