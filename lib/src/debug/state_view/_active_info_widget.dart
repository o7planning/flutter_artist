import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

enum ActiveElementType {
  block,
  item,
  scalar;

  String shortInf() {
    switch (this) {
      case ActiveElementType.block:
        return "B";
      case ActiveElementType.item:
        return "I";
      case ActiveElementType.scalar:
        return "S";
    }
  }
}

class ActiveInfoWidget extends StatelessWidget {
  final TextStyle labelStyle;
  final TextStyle textStyle;
  final ActiveElementType activeElementType;
  final String? activeUIComponentName;
  final String? xActiveUIComponentName;
  final Function() checkAgain;

  const ActiveInfoWidget({
    super.key,
    required this.activeElementType,
    required this.activeUIComponentName,
    required this.xActiveUIComponentName,
    required this.labelStyle,
    required this.textStyle,
    required this.checkAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Tooltip(
            message: activeUIComponentName != null
                ? "Active UI: $activeUIComponentName"
                : xActiveUIComponentName != null
                    ? "Active UI: $xActiveUIComponentName"
                    : "",
            child: IconLabelText(
              label: "UI A/XActive? (${activeElementType.shortInf()}): ",
              text:
                  "${activeUIComponentName != null} / ${xActiveUIComponentName != null}",
              labelStyle: labelStyle,
              textStyle: textStyle,
            ),
          ),
        ),
        SimpleSmallIconButton(
          iconData: Icons.view_agenda,
          iconSize: 14,
          onPressed: activeUIComponentName == null
              ? null
              : () {
                  checkAgain();
                },
        ),
      ],
    );
  }
}
