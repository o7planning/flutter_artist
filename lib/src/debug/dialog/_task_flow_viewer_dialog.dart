import 'package:flutter/material.dart';
import 'package:flutter_artist/src/debug/dialog/_tip_document_viewer_dialog.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/enums/_tip_document.dart';
import '../../core/widgets/_custom_app_container.dart';
import '../code_flow/_code_flow_viewer.dart';
import '../utils/_dialog_size.dart';

class CodeFlowViewerDialog extends StatefulWidget {
  const CodeFlowViewerDialog({
    super.key,
  });

  @override
  State<CodeFlowViewerDialog> createState() {
    return CodeFlowViewerDialogState();
  }

  static Future<void> showCodeFlowViewerDialog({
    required BuildContext context,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CodeFlowViewerDialog();
      },
    );
  }
}

class CodeFlowViewerDialogState extends State<CodeFlowViewerDialog> {
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
      child: _buildMainWidget(),
    );
    //
    FaAlertDialog alert = FaAlertDialog(
      icon: Icon(
        Icons.code,
        size: 18,
        color: Colors.indigo,
      ),
      titleText: "Code Flow Viewer",
      content: contentWidget,
      contentPadding: EdgeInsets.zero,
      onHelpPressed: () {
        TipDocumentViewerDialog.showTipDocumentDialog(
          context: context,
          tipDocument: TipDocument.codeFlowViewer,
        );
      },
    );
    return alert;
  }

  Widget _buildMainWidget() {
    return const MasterFlowViewer();
  }
}
