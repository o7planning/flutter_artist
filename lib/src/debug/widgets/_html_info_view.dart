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
    return Padding(
      padding: padding,
      child: HtmlSelectableRichText(
        infoAsHtml,
        icon: showIcon
            ? const Icon(
                FaIconConstants.infoIconData,
                size: 16,
              )
            : null,
        tagStyles: {
          'b': TextStyle(fontWeight: FontWeight.bold),
          'i': TextStyle(fontStyle: FontStyle.italic),
        },
        style: style ??
            const TextStyle(
              fontSize: 13,
            ),
      ),
    );
  }
}
