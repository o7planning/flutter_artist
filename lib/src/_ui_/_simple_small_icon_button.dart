part of '../../flutter_artist.dart';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class _SimpleSmallIconButton extends StatelessWidget {
  final Function()? onPressed;
  final IconData iconData;
  final String? text;
  final String? tooltip;
  final double? iconSize;
  final Color? iconColor;
  final bool selected;

  const _SimpleSmallIconButton({
    required this.iconData,
    this.text,
    this.tooltip,
    this.onPressed,
    this.selected = false,
    this.iconSize = 16,
    this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = TextButton.styleFrom(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero, // const Size(30, 30),
      backgroundColor: selected ? Colors.amberAccent : null,
    );
    final Icon icon = Icon(
      iconData,
      size: iconSize ?? 16,
      color: iconColor,
    );
    //
    Widget btn;
    if (text != null) {
      btn = TextButton.icon(
        icon: icon,
        label: Text(text!),
        onPressed: onPressed,
        style: buttonStyle,
      );
    } else {
      btn = TextButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: icon,
      );
    }
    return tooltip == null
        ? btn
        : Tooltip(
            message: tooltip,
            child: btn,
          );
  }
}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
