part of '../../core.dart';

class _XShelfSortViewChange extends XShelf {
  _XShelfSortViewChange({required SortingModel sortingModel})
      : super(
          xShelfType: XShelfType.filterViewChange,
          shelf: sortingModel.shelf,
        ) {
    // Nothing?
  }
}
