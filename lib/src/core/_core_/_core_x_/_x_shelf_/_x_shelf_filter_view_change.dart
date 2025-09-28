part of '../../core.dart';

class _XShelfFilterViewChange extends XShelf {
  _XShelfFilterViewChange({required FilterModel filterModel})
      : super(
          xShelfType: XShelfType.filterViewChange,
          shelf: filterModel.shelf,
        ) {
    // Nothing?
  }
}
