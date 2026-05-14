import 'package:flutter/material.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';

import '../_core_/core.dart';
import '_sort_panel_helper.dart';
import '_sorting_options.dart';
import '_style.dart';
import 'dialog_sort_content.dart';
import 'dialog_sort_panel_style.dart';

/// A sort panel that opens a modal dialog for advanced multi-sort configuration.
class DialogSortPanel<ITEM extends Object> extends SortPanel<ITEM>
    with SortPanelMixin {
  final DialogSortPanelStyle style;

  const DialogSortPanel({
    super.key,
    required super.sortModel,
    this.style = const DialogSortPanelStyle(),
  });

  void _showSortDialog(BuildContext context) {
    final contentKey = GlobalKey<DialogSortContentState>();
    final tokens = context.faTokens;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: SortPanelHelper.getBackgroundColor(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tokens.shortcut.borderRadius),
            side: SortPanelHelper.getBorder(context),
          ),
          title: Text(
            style.title,
            style: style.getTextStyle(context, false).copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          constraints: BoxConstraints(maxWidth: style.dialogMaxWidth),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          content: DialogSortContent(
            key: contentKey,
            sortModel: sortModel,
            style: style,
          ),
          actions: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () =>
                        contentKey.currentState?.resetLocalCriteria(),
                    child: Text(
                      'Reset',
                      style: TextStyle(
                        color: context.faColors.action.ink.danger,
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      style.cancelButtonText,
                      style: TextStyle(
                          color: SortPanelHelper.getTextColor(context, false)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.faColors.action.fill.primary,
                      foregroundColor: context.faColors.action.ink.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            tokens.shortcut.borderRadius / 2),
                      ),
                    ),
                    onPressed: () {
                      final result =
                          contentKey.currentState?.currentArrangement;
                      if (result != null) {
                        sortModel.rearrange(newArrangement: result);
                      }
                      Navigator.pop(context);
                    },
                    child: Text(style.applyButtonText),
                  ),
                ],
              ),
            ),
          ],
          actionsPadding: EdgeInsets.zero,
        );
      },
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    final hasActiveSort = sortModel.hasDirection;

    return InkWell(
      onTap: () => _showSortDialog(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: style.height,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: SortPanelHelper.getBackgroundColor(context),
          border: Border.fromBorderSide(SortPanelHelper.getBorder(context)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              style.triggerIcon,
              size: style.triggerIconSize,
              color: SortPanelHelper.getIconColor(context, hasActiveSort),
            ),
            const SizedBox(width: 8),
            Text(
              style.title,
              style: style.getTextStyle(context, hasActiveSort).copyWith(
                    color: SortPanelHelper.getTextColor(context, hasActiveSort),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
