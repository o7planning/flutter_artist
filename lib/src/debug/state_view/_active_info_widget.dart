import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

class ActiveInfoWidget extends StatelessWidget {
  final TextStyle labelStyle;
  final TextStyle textStyle;
  final String? activeUIComponentName;
  final String? xActiveUIComponentName;

  const ActiveInfoWidget({
    super.key,
    required this.activeUIComponentName,
    required this.xActiveUIComponentName,
    required this.labelStyle,
    required this.textStyle,
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
              label: "UI Active / XActive?: ",
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
                  // block.ui.hasActiveUIComponent();
                },
        ),
      ],
    );
  }
}
