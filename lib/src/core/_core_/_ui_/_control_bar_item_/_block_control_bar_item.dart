part of '../../core.dart';

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
