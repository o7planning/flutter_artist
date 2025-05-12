part of '../../flutter_artist.dart';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class _IconLabelText extends StatelessWidget {
  final Widget? icon;
  final String label;
  final String text;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final Widget? suffixIcon;
  final TextStyle? style;

  const _IconLabelText({
    this.icon,
    this.suffixIcon,
    required this.label,
    required this.text,
    this.style,
    this.labelStyle,
    this.textStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      style: style,
      TextSpan(
        children: [
          if (icon != null)
            WidgetSpan(
              child: icon!,
              alignment: PlaceholderAlignment.middle,
            ),
          if (icon != null)
            const WidgetSpan(
              child: SizedBox(
                width: 2,
              ),
            ),
          TextSpan(
            text: label,
            style: labelStyle ?? const TextStyle(fontWeight: FontWeight.bold),
          ),
          const WidgetSpan(
            child: SizedBox(
              width: 2,
            ),
          ),
          TextSpan(text: text, style: textStyle),
          if (suffixIcon != null)
            const WidgetSpan(
              child: SizedBox(
                width: 2,
              ),
            ),
          if (suffixIcon != null)
            WidgetSpan(
              child: suffixIcon!,
              alignment: PlaceholderAlignment.middle,
            ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
