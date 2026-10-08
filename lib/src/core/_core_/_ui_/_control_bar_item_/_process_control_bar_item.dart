part of '../../core.dart';

class ProzessControlBarItem
    extends ControlBarItem<Prozess, ProzessControlBarItemType> {
  const ProzessControlBarItem.standard(super.type) : super.standard();

  const ProzessControlBarItem.divider()
      : super.standard(ProzessControlBarItemType.divider);

  const ProzessControlBarItem.back()
      : super.standard(ProzessControlBarItemType.back);

  const ProzessControlBarItem.cancel()
      : super.standard(ProzessControlBarItemType.cancel);

  const ProzessControlBarItem.reset()
      : super.standard(ProzessControlBarItemType.reset);

  const ProzessControlBarItem.debugInspector()
      : super.standard(ProzessControlBarItemType.debugInspector);

  ProzessControlBarItem.custom({
    required super.tooltip,
    required super.iconData,
    required super.onPressed,
  }) : super.custom();
}
