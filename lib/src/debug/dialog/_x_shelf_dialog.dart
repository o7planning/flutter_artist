import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../executor/x_shelf/_x_shelf_tree_view.dart';

class XShelfDialog extends StatelessWidget {
  final XShelf xShelf;

  const XShelfDialog({
    required this.xShelf,
    super.key,
  });

  static Future<void> open({
    required BuildContext context,
    required XShelf xShelf,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return XShelfDialog(xShelf: xShelf);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    FaDialog alert = FaDialog(
      titleText: "XShelf Viewer",
      contentPadding: EdgeInsets.zero,
      preferredContentWidth: 800,
      preferredContentHeight: 400,
      content: _buildMainWidget(),
    );
    return alert;
  }

  Widget _buildMainWidget() {
    return XShelfTreeView(
      xShelf: xShelf,
    );
  }
}
