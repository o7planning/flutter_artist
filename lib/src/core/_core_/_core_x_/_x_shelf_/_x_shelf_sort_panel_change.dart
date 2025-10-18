part of '../../core.dart';

class _XShelfSortPanelChange extends XShelf {
  _XShelfSortPanelChange({required SortModel sortModel})
      : super(
          xShelfType: XShelfType.filterViewChange,
          shelf: sortModel.shelf,
        ) {
    // Nothing?
  }
}
