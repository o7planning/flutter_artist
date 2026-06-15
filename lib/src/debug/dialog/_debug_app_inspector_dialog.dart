import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_tip_document.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/widgets/_custom_app_container.dart';
import '../app/_debug_app_view.dart';
import '../utils/_dialog_size.dart';
import '_tip_document_viewer_dialog.dart';

class DebugAppInspectorDialog extends StatefulWidget {
  final Shelf? shelf;

  const DebugAppInspectorDialog({
    required this.shelf,
    super.key,
  });

  @override
  State<DebugAppInspectorDialog> createState() =>
      _DebugAppInspectorDialogState();

  static Future<void> open({
    required BuildContext context,
    required Shelf? shelf,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DebugAppInspectorDialog(shelf: shelf);
      },
    );
  }
}

class _DebugAppInspectorDialogState extends State<DebugAppInspectorDialog> {
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    final Size preferContentSize =
        DialogSizeUtils.calculateDebugDialogSize(context);

    Widget contentWidget = PageStorage(
      bucket: _bucket,
      child: const DebugAppView(
        key: PageStorageKey('MainStorageView'),
      ),
    );

    return FaDialog(
      iconData: FaIconConstants.appIconData,
      titleText: "Debug App Inspector",
      content: contentWidget,
      contentPadding: EdgeInsets.zero,
      preferredContentWidth: preferContentSize.width,
      preferredContentHeight: preferContentSize.height,
      onHelpPressed: () {
        TipDocumentViewerDialog.show(
          context: context,
          tipDocument: TipDocument.debugAppInspector,
        );
      },
    );
  }
}
