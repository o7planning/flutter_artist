part of '../../core.dart';

class _XShelfSortPanelChange extends XShelf {
  _XShelfSortPanelChange({required SortModel sortModel})
      : super(
    xShelfType: XShelfType.filterPanelChange,
    shelf: sortModel.shelf,
  ) {
    // Nothing?
  }
}
