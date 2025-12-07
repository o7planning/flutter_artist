import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../../core/widgets/_custom_app_container.dart';
import '../storage2/_storage_view.dart';
import '../utils/_dialog_size.dart';

class StorageDialog extends StatefulWidget {
  final Shelf? shelf;

  const StorageDialog({
    required this.shelf,
    super.key,
  });

  @override
  State<StorageDialog> createState() {
    return _StorageDialogState();
  }

  static Future<void> showStorageDialog({
    required BuildContext context,
    required Shelf? shelf,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StorageDialog(shelf: shelf);
      },
    );
  }
}

class _StorageDialogState extends State<StorageDialog> {
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
      child: StorageView(),
    );

    FaAlertDialog alert = FaAlertDialog(
      titleText: "Storage Viewer",
      content: contentWidget,
      contentPadding: EdgeInsets.zero,
    );
    return alert;
  }
}
