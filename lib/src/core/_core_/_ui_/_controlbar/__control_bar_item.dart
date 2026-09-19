part of '../../core.dart';

// OWNER: Block or Scalar.
class ControlBarItem<OWNER extends Object, ITEM_TYPE extends Enum> {
  final ITEM_TYPE? type;

  final String? tooltip;
  final IconData? iconData;
  final void Function(OWNER owner, ITEM_TYPE type)? onPressed;
  final Widget? customWidget;

  const ControlBarItem.standard(this.type)
      : onPressed = null,
        iconData = null,
        tooltip = null,
        customWidget = null;

  const ControlBarItem.custom({
    required String this.tooltip,
    required IconData this.iconData,
    required this.onPressed,
  })  : type = null,
        customWidget = null;
}

class BlockControlBarItem
    extends ControlBarItem<Block, BlockControlBarItemType> {
  const BlockControlBarItem.standard(super.type) : super.standard();

  const BlockControlBarItem.divider()
      : super.standard(BlockControlBarItemType.divider);

  const BlockControlBarItem.back()
      : super.standard(BlockControlBarItemType.back);

  const BlockControlBarItem.refresh()
      : super.standard(BlockControlBarItemType.refresh);

  const BlockControlBarItem.query()
      : super.standard(BlockControlBarItemType.query);

  const BlockControlBarItem.create()
      : super.standard(BlockControlBarItemType.create);

  const BlockControlBarItem.edit()
      : super.standard(BlockControlBarItemType.edit);

  const BlockControlBarItem.save()
      : super.standard(BlockControlBarItemType.save);

  const BlockControlBarItem.delete()
      : super.standard(BlockControlBarItemType.delete);

  const BlockControlBarItem.reset()
      : super.standard(BlockControlBarItemType.reset);

  const BlockControlBarItem.debugFilter()
      : super.standard(BlockControlBarItemType.debugFilter);

  const BlockControlBarItem.debugForm()
      : super.standard(BlockControlBarItemType.debugForm);

  BlockControlBarItem.custom({
    required super.tooltip,
    required super.iconData,
    required super.onPressed,
  }) : super.custom();
}

class ScalarControlBarItem
    extends ControlBarItem<Scalar, ScalarControlBarItemType> {
  const ScalarControlBarItem.standard(super.type) : super.standard();

  const ScalarControlBarItem.divider()
      : super.standard(ScalarControlBarItemType.divider);

  const ScalarControlBarItem.back()
      : super.standard(ScalarControlBarItemType.back);

  const ScalarControlBarItem.query()
      : super.standard(ScalarControlBarItemType.query);

  const ScalarControlBarItem.debugFilter()
      : super.standard(ScalarControlBarItemType.debugFilter);

  ScalarControlBarItem.custom({
    required super.tooltip,
    required super.iconData,
    required super.onPressed,
  }) : super.custom();
}

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
