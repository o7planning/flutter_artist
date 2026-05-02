import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/enums/_tip_document.dart';
import '../code_flow/_execution_trace_viewer.dart';
import '../utils/_dialog_size.dart';
import '_tip_document_viewer_dialog.dart';

class CodeFlowInspectorDialog extends StatefulWidget {
  const CodeFlowInspectorDialog({
    super.key,
  });

  @override
  State<CodeFlowInspectorDialog> createState() {
    return CodeFlowInspectorDialogState();
  }

  static Future<void> open({
    required BuildContext context,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CodeFlowInspectorDialog();
      },
    );
  }
}

class CodeFlowInspectorDialogState extends State<CodeFlowInspectorDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size preferContentSize = DialogSizeUtils.calculateDebugDialogSize(context);

    FaDialog alert = FaDialog(
      iconData: Icons.code,
      titleText: "Code Flow Inspector",
      content: _buildMainWidget(),
      preferredContentWidth: preferContentSize.width,
      preferredContentHeight: preferContentSize.height,
      contentPadding: EdgeInsets.zero,
      onHelpPressed: () {
        TipDocumentViewerDialog.open(
          context: context,
          tipDocument: TipDocument.codeFlowInspector,
        );
      },
    );
    return alert;
  }

  Widget _buildMainWidget() {
    return const ExecutionTraceViewer();
  }
}
