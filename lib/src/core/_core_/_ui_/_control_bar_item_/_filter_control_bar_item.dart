part of '../../core.dart';

class FilterControlBarItem
    extends ControlBarItem<FilterModel, FilterControlBarItemType> {
  const FilterControlBarItem.standard(super.type) : super.standard();

  const FilterControlBarItem.divider()
      : super.standard(FilterControlBarItemType.divider);

  const FilterControlBarItem.back()
      : super.standard(FilterControlBarItemType.back);

  const FilterControlBarItem.debugFilter()
      : super.standard(FilterControlBarItemType.debugFilter);

  FilterControlBarItem.custom({
    required super.tooltip,
    required super.iconData,
    required super.onPressed,
  }) : super.custom();
}
