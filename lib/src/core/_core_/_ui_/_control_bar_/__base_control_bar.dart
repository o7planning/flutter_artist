part of '../../core.dart';

abstract class BaseControlBar<
        OWNER extends Object, //
        ITEM_TYPE extends Enum, //
        CONTROL_BAR_ITEM extends ControlBarItem<OWNER, ITEM_TYPE>>
    extends _ContextProviderView {
  final ControlBarStyle style;
  final List<CONTROL_BAR_ITEM> leftItems;
  final List<CONTROL_BAR_ITEM> rightItems;

  const BaseControlBar({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    this.style = const ControlBarStyle(),
    this.leftItems = const [],
    this.rightItems = const [],
  });
}
