import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../../core/widgets/_custom_app_container.dart';
import '../executor/ui/_debug_task_unit_queue_view.dart';
import '../utils/_dialog_size.dart';

class DebugTaskUnitQueueDialog extends StatelessWidget {
  const DebugTaskUnitQueueDialog({
    super.key,
  });

  static Future<void> showTaskUnitQueueDialog({
    required BuildContext context,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DebugTaskUnitQueueDialog();
      },
    );
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
      titleText: "Task Unit Queue Viewer",
      content: contentWidget,
      contentPadding: EdgeInsets.zero,
    );
    return alert;
  }

  Widget _buildMainWidget() {
    return DebugTaskUnitQueueView(
      taskUnitQueue: FlutterArtist.debugTaskUnitQueue,
    );
  }
}
