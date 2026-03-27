part of '../../core.dart';

// OWNER: Block or Scalar.
class ControlBarItem<OWNER extends Object, ITEM_TYPE extends Enum> {
  final ITEM_TYPE? type;

  final String? tooltip;
  final IconData? iconData;
  final Function(OWNER owner, ITEM_TYPE itemType)? onPressed;
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
