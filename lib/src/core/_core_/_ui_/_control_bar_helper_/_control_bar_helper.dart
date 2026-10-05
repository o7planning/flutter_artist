part of '../../core.dart';

class ControlBarHelper {
  static Widget buildControlBarButton(
    BuildContext context, {
    required ControlBarStyle style,
    required String tooltip,
    required IconData iconData,
    bool onAction = false,
    required VoidCallback? onPressed,
    Color? customColor,
  }) {
    if (style.buttonBuilder != null) {
      return style.buttonBuilder!(
        context,
        iconData: iconData,
        onPressed: onPressed,
        onAction: onAction,
        tooltip: tooltip,
      );
    }

    return _ControlBarButton(
      tooltip: tooltip,
      iconData: iconData,
      onAction: onAction,
      onPressed: onPressed,
      //
      iconColor: onPressed == null
          ? style.disabledIconColor
          : (customColor ?? style.activeIconColor),
    );
  }
}
