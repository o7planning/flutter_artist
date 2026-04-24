import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_tip_document.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/widgets/_custom_app_container.dart';
import '../storage/_storage_view.dart';
import '../utils/_dialog_size.dart';
import '_tip_document_viewer_dialog.dart';

class DebugStorageViewerDialog extends StatefulWidget {
  final Shelf? shelf;

  const DebugStorageViewerDialog({
    required this.shelf,
    super.key,
  });

  @override
  State<DebugStorageViewerDialog> createState() =>
      _DebugStorageViewerDialogState();

  static Future<void> open({
    required BuildContext context,
    required Shelf? shelf,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DebugStorageViewerDialog(shelf: shelf);
      },
    );
  }
}

class _DebugStorageViewerDialogState extends State<DebugStorageViewerDialog> {
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    final Size preferContentSize =
        DialogSizeUtils.calculateDebugDialogSize(context);

    Widget contentWidget = PageStorage(
      bucket: _bucket,
      child: const StorageView(
        key: PageStorageKey('MainStorageView'),
      ),
    );

    return FaDialog(
      iconData: FaIconConstants.storageIconData,
      titleText: "Debug Storage Viewer",
      content: contentWidget,
      contentPadding: EdgeInsets.zero,
      preferredContentWidth: preferContentSize.width,
      preferredContentHeight: preferContentSize.height,
      onHelpPressed: () {
        TipDocumentViewerDialog.open(
          context: context,
          tipDocument: TipDocument.debugStorageViewer,
        );
      },
    );
  }
}
