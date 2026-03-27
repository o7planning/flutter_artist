import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_core_/core.dart';
import '../../../core/icon/icon_constants.dart';
import '../../../core/utils/_class_utils.dart';

class ShelfInfoView extends StatelessWidget {
  final Shelf? shelf;

  const ShelfInfoView({super.key, required this.shelf});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      titleAlignment: ListTileTitleAlignment.top,
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 0,
      horizontalTitleGap: 5,
      dense: true,
      visualDensity: const VisualDensity(
        horizontal: -3,
        vertical: -3,
      ),
      leading: Image.asset(
        "packages/flutter_artist/static-rs/shelf.png",
        width: 40,
        height: 40,
      ),
      trailing: Tooltip(
        message: "Show Shelf Structure",
        child: SimpleSmallIconButton(
          iconData: FaIconConstants.shelfStructureIconData,
          iconSize: 18,
          onPressed: shelf == null
              ? null
              : () {
                  shelf!.showDebugShelfStructureViewerDialog();
                },
        ),
      ),
      title: Text(
        getClassName(shelf),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        shelf?.description ?? '[No Description]',
        style: TextStyle(
          fontSize: 12,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
