import 'package:flutter/material.dart';
import 'package:flutter_artist/src/debug/dialog/_tip_document_viewer_dialog.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart'
    as dialogs;

import '../../core/_core_/core.dart';
import '../../core/enums/_tip_document.dart';
import '../../core/utils/_class_utils.dart';
import '../form/_form_data_debug_view.dart';
import '../shelf/_shelf_structure_graph_view.dart';
import '../utils/_dialog_size.dart';

class DebugFormModelViewerDialog extends StatefulWidget {
  final FormModel formModel;
  final String locationInfo;

  const DebugFormModelViewerDialog({
    required this.formModel,
    required this.locationInfo,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _DebugFormModelViewerDialogState();
  }

  static Future<void> open({
    required BuildContext context,
    required String locationInfo,
    required FormModel formModel,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DebugFormModelViewerDialog(
          formModel: formModel,
          locationInfo: locationInfo,
        );
      },
    );
  }
}

class _DebugFormModelViewerDialogState
    extends State<DebugFormModelViewerDialog> {
  bool showFormData = true;

  @override
  Widget build(BuildContext context) {
    Size size = DialogSizeUtils.calculateDebugDialogSize(context);

    // Set up the AlertDialog
    dialogs.FaAlertDialog alert = dialogs.FaAlertDialog(
      titleText: showFormData
          ? "${getClassName(widget.formModel)} - Debug Form Model Viewer"
          : "${getClassName(widget.formModel.block.shelf)} - Structure",
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
          tipDocument: TipDocument.debugFormModelViewer,
        );
      },
    );
    return alert;
  }

  Widget _buildMainContent(BuildContext context, double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: showFormData
          ? FormDataView(
              formModel: widget.formModel,
              locationInfo: widget.locationInfo,
              onPressedShelf: () {
                setState(() {
                  showFormData = false;
                });
              },
            )
          : ShelfStructureGraphView(
              shelf: widget.formModel.block.shelf,
              onPressedBack: () {
                setState(() {
                  showFormData = true;
                });
              },
            ),
    );
  }
}
