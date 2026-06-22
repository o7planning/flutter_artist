import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../executor/ui/_debug_executor_view.dart';
import '../utils/_dialog_size.dart';

class DebugExecutorDialog extends StatelessWidget {
  const DebugExecutorDialog({
    super.key,
  });

  static Future<void> open({
    required BuildContext context,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DebugExecutorDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size preferContentSize =
        DialogSizeUtils.calculateDebugDialogSize(context);

    Widget contentWidget = _buildMainWidget();

    FaDialog alert = FaDialog(
      titleText: "Task Unit Queue Viewer",
      preferredContentWidth: preferContentSize.width,
      preferredContentHeight: preferContentSize.height,
      content: contentWidget,
      contentPadding: EdgeInsets.zero,
    );
    return alert;
  }

  Widget _buildMainWidget() {
    return DebugExecutorView(
      debugXShelfQueue: FlutterArtist.debugTaskUnitQueue,
    );
  }
}
