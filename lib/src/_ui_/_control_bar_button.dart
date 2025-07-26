part of '../../flutter_artist.dart';

class _ControlBarButton extends StatelessWidget {
  final String tooltip;
  final IconData iconData;
  final Color? iconColor;
  final bool onAction;
  final Function()? onPressed;

  static const double iconSize = 18;

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
    return SizedBox(
      height: iconSize,
      width: iconSize,
      child: onAction
          ? const CircularProgressIndicator()
          : SimpleSmallIconButton(
        tooltip: tooltip,
        iconData: iconData,
        // iconSize: iconSize,
        iconColor: iconColor,
        onPressed: onPressed,
      ),
    );
  }
}
