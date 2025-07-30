import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../widgets/_custom_app_container.dart';
import '../_code_flow_/_code_flow_viewer.dart';
import '../_dialog_size.dart';

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

    FaAlertDialog alert = FaAlertDialog(
      titleText: "Code Flow Viewer",
      content: contentWidget,
      contentPadding: EdgeInsets.zero,
    );
    return alert;
  }

  Widget _buildMainWidget() {
    return const CodeFlowViewer();
  }
}
