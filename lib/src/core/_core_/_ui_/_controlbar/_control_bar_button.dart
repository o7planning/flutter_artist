part of '../../core.dart';

class _ControlBarButton extends StatelessWidget {
  final String tooltip;
  final IconData iconData;
  final Color? iconColor;
  final bool onAction;
  final Function()? onPressed;

  static const double iconSize = 16;

  const _ControlBarButton({
    super.key,
    required this.tooltip,
    required this.onPressed,
    required this.onAction,
    required this.iconData,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color baseColor = iconColor ?? FaColorUtils.primaryAction(context);
    final effectiveColor =
        onPressed == null ? baseColor.withValues(alpha: 0.3) : baseColor;

    return SizedBox(
      height: iconSize + 4,
      width: iconSize + 4,
      child: Tooltip(
        message: onAction ? "Processing..." : tooltip,
        child: InkResponse(
          onTap: onAction ? null : onPressed,
          radius: (iconSize + 10) / 2,
          child: Center(
            child: onAction
                ? SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
                    ),
                  )
                : Icon(
                    iconData,
                    size: iconSize,
                    color: effectiveColor,
                  ),
          ),
        ),
      ),
    );
  }
}
