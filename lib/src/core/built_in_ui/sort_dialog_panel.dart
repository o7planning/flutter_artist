import 'package:flutter/material.dart';
import 'package:flutter_artist_theme/flutter_artist_theme.dart';

import '../_core_/core.dart';
import '_tile.dart';
import 'sort_dialog_content.dart';
import 'sort_dialog_panel_style.dart';

/// A sort panel that opens a modal dialog for advanced multi-sort configuration.
class SortDialogPanel<ITEM extends Object> extends SortPanel<ITEM>
    with SortPanelMixin {
  final SortDialogPanelStyle style;

  const SortDialogPanel({
    super.key,
    required super.sortModel,
    this.style = const SortDialogPanelStyle(),
  });

  void _showSortDialog(BuildContext context) {
    final contentKey = GlobalKey<SortDialogContentState>();
    final tokens = context.faTokens;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: tokens.shortcut.surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tokens.shortcut.borderRadius),
            side: tokens.shortcut.border,
          ),
          title: Text(style.title, style: tokens.shortcut.headerTextStyle),
          constraints: BoxConstraints(maxWidth: style.dialogMaxWidth),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          content: SortDialogContent(
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
                    child: const Text('Reset',
                        style: TextStyle(color: Colors.redAccent)),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(style.cancelButtonText),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
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
          border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              style.triggerIcon,
              size: style.triggerIconSize,
              color: hasActiveSort
                  ? Theme.of(context).primaryColor
                  : style.triggerIconColor,
            ),
            const SizedBox(width: 8),
            Text(
              style.title,
              style: style.textStyle.copyWith(
                color: hasActiveSort ? Theme.of(context).primaryColor : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
