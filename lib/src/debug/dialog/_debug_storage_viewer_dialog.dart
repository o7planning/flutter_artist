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
  State<DebugStorageViewerDialog> createState() {
    return _DebugStorageViewerDialogState();
  }

  static Future<void> open({
    required BuildContext context,
    required Shelf? shelf,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DebugStorageViewerDialog(shelf: shelf);
      },
    );
  }
}

class _DebugStorageViewerDialogState extends State<DebugStorageViewerDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = DialogSizeUtils.calculateDebugDialogSize(context);

    Widget contentWidget = CustomAppContainer(
      padding: const EdgeInsets.all(2),
      width: size.width,
      height: size.height,
      child: StorageView(),
    );

    FaAlertDialog alert = FaAlertDialog(
      icon: Icon(
        FaIconConstants.storageIconData,
        size: 16,
        color: Colors.indigo,
      ),
      titleText: "Debug Storage Viewer",
      content: contentWidget,
      contentPadding: EdgeInsets.zero,
      onHelpPressed: () {
        TipDocumentViewerDialog.open(
          context: context,
          tipDocument: TipDocument.debugStorageViewer,
        );
      },
    );
    return alert;
  }
}
