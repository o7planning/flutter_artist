import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../../core/widgets/_custom_app_container.dart';
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
    Size size = calculatePreferredDialogSize(
      context,
      preferredWidth: 800,
      preferredHeight: 400,
    );

    Widget contentWidget = CustomAppContainer(
      padding: const EdgeInsets.all(2),
      width: size.width,
      height: size.height,
      child: _buildMainWidget(),
    );

    FaAlertDialog alert = FaAlertDialog(
      titleText: "XShelf Viewer",
      content: contentWidget,
      contentPadding: EdgeInsets.zero,
    );
    return alert;
  }

  Widget _buildMainWidget() {
    return XShelfTreeView(
      xShelf: xShelf,
    );
  }
}
