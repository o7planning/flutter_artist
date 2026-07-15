import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';

import '../../../core/_core_/core.dart';
import '../dialogs/block_sync_session_state_dialog.dart';
import '_debug_style_utils.dart';

class BlockQueryInfoWidget extends StatelessWidget {
  final Block block;
  final TextStyle labelStyle;
  final TextStyle textStyle;

  const BlockQueryInfoWidget({
    super.key,
    required this.block,
    required this.labelStyle,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    DebugBlockSyncSessionState? queryCondition = block.debug.syncSessionState;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Tooltip(
            message: "performQueryCount / performQueryByItemIdsCount",
            child: IconLabelText(
              label: "Query Count: ",
              text:
                  "${block.debug.performQueryCount} / ${block.debug.performQueryByItemIdsCount}",
              labelStyle: DebugStyleUtils.getLabelStyle(context),
            ),
          ),
        ),
        SimpleSmallIconButton(
          iconData: Icons.view_agenda,
          iconSize: 14,
          iconColor: block.blockSyncSessionState == null
              ? context.faColors.action.ink.success
              : context.faColors.action.ink.error,
          onPressed: () {
            block.showDebugSyncSessionState(
              context: context,
            );
          },
        ),
      ],
    );
  }
}
