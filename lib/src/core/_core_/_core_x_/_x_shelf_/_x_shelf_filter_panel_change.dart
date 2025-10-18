part of '../../core.dart';

class _XShelfFilterPanelChange extends XShelf {
  _XShelfFilterPanelChange({required FilterModel filterModel})
      : super(
          xShelfType: XShelfType.filterPanelChange,
          shelf: filterModel.shelf,
        ) {
    // Nothing?
  }
}
