import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../__root_debug_view.dart';

class RootDebugDialog extends StatelessWidget {
  final Shelf shelf;

  const RootDebugDialog({
    required this.shelf,
    super.key,
  });

  static Future<void> open({
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
    final Size preferContentSize = calculatePreferredDialogSize(
      context,
      preferredWidth: 1000,
      preferredHeight: 600,
    );

    FaDialog alert = FaDialog(
      titleText: "Root Debug",
      content: _buildMainWidget(),
      contentPadding: EdgeInsets.zero,
      preferredContentWidth: preferContentSize.width,
      preferredContentHeight: preferContentSize.height,
    );
    return alert;
  }

  Widget _buildMainWidget() {
    return RootDebugView();
  }
}
