import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart'
    as dialogs;

import '../../core/_core_/core.dart';
import '../../core/enums/_tip_document.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/_class_utils.dart';
import '../shelf/_shelf_structure_graph_view.dart';
import '../utils/_dialog_size.dart';
import '_tip_document_viewer_dialog.dart';

class DebugShelfStructureViewerDialog extends StatefulWidget {
  final Shelf shelf;

  const DebugShelfStructureViewerDialog({
    required this.shelf,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _DebugShelfStructureViewerDialogState();
  }

  static Future<void> open({
    required BuildContext context,
    required Shelf shelf,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DebugShelfStructureViewerDialog(
          shelf: shelf,
        );
      },
    );
  }
}

class _DebugShelfStructureViewerDialogState
    extends State<DebugShelfStructureViewerDialog> {
  @override
  Widget build(BuildContext context) {
    Size size = DialogSizeUtils.calculateDebugDialogSize(context);

    // Set up the AlertDialog
    dialogs.FaAlertDialog alert = dialogs.FaAlertDialog(
      icon: Icon(
        FaIconConstants.shelfStructureIconData,
        size: 18,
      ),
      titleText: "Debug Shelf Structure Viewer - ${getClassName(widget.shelf)}",
      contentPadding: const EdgeInsets.all(5),
      content: _buildMainContent(
        context,
        size.width,
        size.height,
      ),
      clipBehavior: Clip.hardEdge,
      onHelpPressed: () {
        TipDocumentViewerDialog.open(
          context: context,
          tipDocument: TipDocument.debugShelfStructureViewer,
        );
      },
    );
    return alert;
  }

  Widget _buildMainContent(BuildContext context, double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: ShelfStructureGraphView(
        shelf: widget.shelf,
        onPressedBack: null,
      ),
    );
  }
}
