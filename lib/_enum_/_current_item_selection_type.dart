part of '../flutter_artist.dart';

enum CurrentItemSelectionType {
  selectAsCurrentToEdit,
  selectAsCurrentToShow,
  selectAsCurrentForDefault,
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
