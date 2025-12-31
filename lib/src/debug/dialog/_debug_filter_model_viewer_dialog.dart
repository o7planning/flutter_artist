import 'package:flutter/material.dart';
import 'package:flutter_artist/src/debug/dialog/_tip_document_viewer_dialog.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_tip_document.dart';
import '../../core/utils/_class_utils.dart';
import '../filter/_filter_data_debug_view.dart';
import '../shelf/_shelf_structure_graph_view.dart';
import '../utils/_dialog_size.dart';

class DebugFilterModelViewerDialog extends StatefulWidget {
  final FilterModel filterModel;
  final String locationInfo;

  const DebugFilterModelViewerDialog({
    required this.filterModel,
    required this.locationInfo,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _DebugFilterModelViewerDialogState();
  }

  static Future<void> open({
    required BuildContext context,
    required String locationInfo,
    required FilterModel filterModel,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DebugFilterModelViewerDialog(
          filterModel: filterModel,
          locationInfo: locationInfo,
        );
      },
    );
  }
}

class _DebugFilterModelViewerDialogState
    extends State<DebugFilterModelViewerDialog> {
  bool showFormData = true;

  @override
  Widget build(BuildContext context) {
    Size size = DialogSizeUtils.calculateDebugDialogSize(context);

    // Set up the AlertDialog
    FaAlertDialog alert = FaAlertDialog(
      titleText: showFormData
          ? "${getClassName(widget.filterModel)} - Debug Filter Model Viewer"
          : "${getClassName(widget.filterModel.shelf)} - Structure",
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
          tipDocument: TipDocument.debugFilterModelViewer,
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
          ? FilterDataDebugView(
              filterModel: widget.filterModel,
              onPressedShelf: () {
                setState(() {
                  showFormData = false;
                });
              },
            )
          : ShelfStructureGraphView(
              shelf: widget.filterModel.shelf,
              onPressedBack: () {
                setState(() {
                  showFormData = true;
                });
              },
            ),
    );
  }
}
