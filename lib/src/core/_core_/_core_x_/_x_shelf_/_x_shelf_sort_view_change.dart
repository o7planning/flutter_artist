part of '../../core.dart';

class _XShelfSortViewChange extends XShelf {
  _XShelfSortViewChange({required SortModel sortModel})
      : super(
          xShelfType: XShelfType.filterViewChange,
          shelf: sortModel.shelf,
        ) {
    // Nothing?
  }
}
