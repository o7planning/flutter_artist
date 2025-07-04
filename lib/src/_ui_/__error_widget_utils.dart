part of '../../flutter_artist.dart';

final Color _quick_circleAvatarBgColor = Colors.deepOrange[50]!;
final double _quick_circleAvatarRadius = 20;

final double _quick_iconSize = 16;
final Color _quick_iconColor_error = Colors.red;
final Color _quick_iconColor_enable = Colors.indigo;
final Color _quick_iconColor_disable = Colors.grey;

class _QuickSuggestionButton extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final String tooltip;
  final Function()? onPressed;

  const _QuickSuggestionButton({
    required this.iconData,
    required this.iconColor,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: _quick_circleAvatarRadius,
      backgroundColor: _quick_circleAvatarBgColor,
      child: Tooltip(
        message: tooltip,
        child: IconButton(
          icon: Icon(
            iconData,
            size: _quick_iconSize,
            color: _quick_iconColor_error,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
