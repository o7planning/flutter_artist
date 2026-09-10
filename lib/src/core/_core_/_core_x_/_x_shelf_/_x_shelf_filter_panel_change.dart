part of '../../core.dart';

class _XShelfFilterPanelChange extends XShelf {
  _XShelfFilterPanelChange({
    required FilterModel filterModel,
  }) : super(
    xShelfType: XShelfType.filterPanelChange,
    shelf: filterModel.shelf,
  ) {
    XFilterModel thisXFilterModel = xFilterModelMap[filterModel.name]!;
    thisXFilterModel._filterLoadHint = FilterLoadHint.force;
  }
}
