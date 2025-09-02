import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../../core/widgets/_custom_app_container.dart';
import '../__root_debug_view.dart';

class RootDebugDialog extends StatelessWidget {
  final Shelf shelf;

  const RootDebugDialog({
    required this.shelf,
    super.key,
  });

  static Future<void> showRootDebug({
    required BuildContext context,
    required Shelf shelf,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return RootDebugDialog(shelf: shelf);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = calculatePreferredDialogSize(
      context,
      preferredWidth: 1000,
      preferredHeight: 600,
    );

    Widget contentWidget = CustomAppContainer(
      padding: const EdgeInsets.all(2),
      width: size.width,
      height: size.height,
      child: _buildMainWidget(),
    );

    FaAlertDialog alert = FaAlertDialog(
      titleText: "Root Debug",
      content: contentWidget,
      contentPadding: EdgeInsets.zero,
    );
    return alert;
  }

  Widget _buildMainWidget() {
    return RootDebugView();
  }
}
