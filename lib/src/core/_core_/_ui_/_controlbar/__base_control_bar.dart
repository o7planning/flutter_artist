part of '../../core.dart';

abstract class BaseControlBar<OWNER extends Object, ITEM_TYPE extends Enum>
    extends _ContextProviderView {
  final ControlBarStyle style;
  final List<ControlBarItem<OWNER, ITEM_TYPE>> leftItems;
  final List<ControlBarItem<OWNER, ITEM_TYPE>> rightItems;

  const BaseControlBar({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    this.style = const ControlBarStyle(),
    this.leftItems = const [],
    this.rightItems = const [],
  });
}
