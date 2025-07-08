part of '../../flutter_artist.dart';

final Color _quick_circleAvatarBgColor = Colors.deepOrange[50]!;
final double _quick_circleAvatarRadius = 20;

final double _quick_iconSize = 16;
const Color _quick_iconColor_error = Colors.red;
const Color _quick_iconColor_enable = Colors.indigo;
const Color _quick_iconColor_disable = Colors.grey;

enum QuickSuggestionMode {
  showIfError;
}

enum QuickSuggestionType {
  normal,
  error,
  fatal;
}

class _QuickSuggestionButton extends StatelessWidget {
  final QuickSuggestionType suggestionType;
  final IconData iconData;
  final Color? iconColor;
  final String tooltip;
  final Function()? onPressed;

  const _QuickSuggestionButton.fatal({
    required this.tooltip,
    required this.onPressed,
  })
      : suggestionType = QuickSuggestionType.fatal,
        iconData = _formErrorDisabledIconData,
        iconColor = _quick_iconColor_error;

  const _QuickSuggestionButton.error({
    required this.tooltip,
    required this.onPressed,
  })
      : suggestionType = QuickSuggestionType.error,
        iconData = _formErrorModeIconData,
        iconColor = _quick_iconColor_error;

  const _QuickSuggestionButton.restore({
    required this.tooltip,
    required this.onPressed,
  })
      : suggestionType = QuickSuggestionType.normal,
        iconData = _formErrorRollbackIconData,
        iconColor = null;

  const _QuickSuggestionButton.reQuery({
    required this.tooltip,
    required this.onPressed,
  })
      : suggestionType = QuickSuggestionType.normal,
        iconData = _formQueryIconData,
        iconColor = null;

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
            color: onPressed == null
                ? _quick_iconColor_disable
                : iconColor ?? _quick_iconColor_enable,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class _QuickSuggestionButtonsBar extends StatelessWidget {
  final List<_QuickSuggestionButton> children;

  const _QuickSuggestionButtonsBar({required this.children});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: children,
    );
  }
}
