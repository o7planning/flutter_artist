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
    Size preferContentSize = calculatePreferredDialogSize(
      context,
      preferredWidth: 500,
      preferredHeight: 320,
    );
    //
    Widget contentWidget = CustomAppContainer(
      child: Text("Code Flow Settings"),
    );

    FaDialog alert = FaDialog(
      titleText: "Code Flow Settings",
      preferredContentWidth: preferContentSize.width,
      preferredContentHeight: preferContentSize.height,
      iconData: Icons.settings,
      content: contentWidget,
      contentPadding: EdgeInsets.zero,
    );
    return alert;
  }
}
