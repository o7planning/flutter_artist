import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';

import '../../../core/_core_/core.dart';

class BlockDataStateWidget extends StatelessWidget {
  final Block block;
  final TextStyle labelStyle;
  final TextStyle textStyle;
  final Function() checkAgain;

  const BlockDataStateWidget({
    super.key,
    required this.block,
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
          child: IconLabelText(
            label: "Data State: ",
            text: block.dataState.name,
            labelStyle: labelStyle,
            textStyle: textStyle,
            endIcon: block.dataState.isStale
                ? Tooltip(
                    message: "Is Stale",
                    child: Icon(
                      Icons.pending_actions,
                      size: 18,
                      color: context.faColors.ink.error,
                    ),
                  )
                : null,
          ),
        ),
        SimpleSmallIconButton(
          iconData: Icons.view_agenda,
          iconSize: 14,
          iconColor: block.hasError
              ? context.faColors.action.ink.error
              : context.faColors.action.ink.success,
          onPressed: block.hasError
              ? () {
                  block.showBlockErrorViewerDialog(context);
                }
              : null,
        ),
      ],
    );
  }
}
