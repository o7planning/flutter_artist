import 'package:flutter/material.dart';
import 'package:flutter_artist/src/core/icon/icon_constants.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart'
    as dialogs;

import '../../core/_core_/core.dart';
import '../../core/utils/_class_utils.dart';
import '../shelf/_shelf_structure_graph_view.dart';
import '../utils/_dialog_size.dart';

class ShelfStructureViewDialog extends StatefulWidget {
  final Shelf shelf;

  const ShelfStructureViewDialog({
    required this.shelf,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _ShelfStructureViewDialogState();
  }

  static Future<void> showShelfStructureViewDialog({
    required BuildContext context,
    required Shelf shelf,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ShelfStructureViewDialog(
          shelf: shelf,
        );
      },
    );
  }
}

class _ShelfStructureViewDialogState extends State<ShelfStructureViewDialog> {
  @override
  Widget build(BuildContext context) {
    Size size = DialogSizeUtils.calculateDebugDialogSize(context);

    // Set up the AlertDialog
    dialogs.FaAlertDialog alert = dialogs.FaAlertDialog(
      icon: Icon(
        FaIconConstants.shelfStructureIconData,
        size: 18,
      ),
      titleText: "${getClassName(widget.shelf)} - Structure",
      contentPadding: const EdgeInsets.all(5),
      content: _buildMainContent(
        context,
        size.width,
        size.height,
      ),
      clipBehavior: Clip.hardEdge,
    );
    return alert;
  }

  Widget _buildMainContent(BuildContext context, double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: ShelfStructureGraphView(
        shelf: widget.shelf,
        onPressedBack: null,
      ),
    );
  }
}
