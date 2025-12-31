import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/widgets/_custom_app_container.dart';

class CodeFlowSettingsDialog extends StatefulWidget {
  const CodeFlowSettingsDialog({
    super.key,
  });

  @override
  State<CodeFlowSettingsDialog> createState() {
    return _CodeFlowSettingsDialogState();
  }

  static Future<void> open({
    required BuildContext context,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CodeFlowSettingsDialog();
      },
    );
  }
}

class _CodeFlowSettingsDialogState extends State<CodeFlowSettingsDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = calculatePreferredDialogSize(
      context,
      preferredWidth: 500,
      preferredHeight: 320,
    );
    //
    Widget contentWidget = CustomAppContainer(
      padding: const EdgeInsets.all(2),
      width: size.width,
      height: size.height,
      child: Text("Code Flow Settings"),
    );

    FaAlertDialog alert = FaAlertDialog(
      titleText: "Code Flow Settings",
      icon: Icon(Icons.settings, size: 18),
      content: contentWidget,
      contentPadding: EdgeInsets.zero,
    );
    return alert;
  }
}
