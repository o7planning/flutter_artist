part of '../../core.dart';

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
