import 'package:flutter/material.dart';

import '../../core/icon/icon_constants.dart';
import '../../core/widgets/_html_selectable_rich_text.dart';

class HtmlInfoView extends StatelessWidget {
  final bool showIcon;
  final String infoAsHtml;
  final EdgeInsets padding;
  final TextStyle? style;

  const HtmlInfoView({
    super.key,
    this.showIcon = true,
    required this.infoAsHtml,
    this.padding = const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: padding,
      child: HtmlSelectableRichText(
        infoAsHtml,
        icon: showIcon
            ? Icon(
                FaIconConstants.infoIconData,
                size: 16,
                color: colorScheme.primary,
              )
            : null,
        tagStyles: {
          'b': TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
          'i': TextStyle(
            fontStyle: FontStyle.italic,
            color: colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        },
        style: style ??
            TextStyle(
              fontSize: 13,
              color: colorScheme.onSurface.withValues(alpha: 0.9),
            ),
      ),
    );
  }
}
