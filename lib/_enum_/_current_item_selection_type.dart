part of '../flutter_artist.dart';

enum CurrentItemSelectionType {
  selectItemAsCurrentIfNeed, // DEFAULT.
  selectItemAsCurrent,
  selectItemAsCurrentAndLoadForm,
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
