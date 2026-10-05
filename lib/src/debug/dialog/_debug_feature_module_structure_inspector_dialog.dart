import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart'
    as dialogs;

import '../../core/_core_/core.dart';
import '../../core/enums/_enums.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/__utils.dart';

import '../feature_module/activity/__activity_structure_graph_view.dart';
import '../feature_module/shelf/__shelf_structure_graph_view.dart';
import '../utils/_dialog_size.dart';
import '_tip_document_viewer_dialog.dart';

class DebugFeatureModuleStructureInspectorDialog extends StatefulWidget {
  final FeatureModule module;

  const DebugFeatureModuleStructureInspectorDialog({
    required this.module,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _DebugFeatureModuleStructureInspectorDialogState();
  }

  static Future<void> show({
    required BuildContext context,
    required FeatureModule module,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DebugFeatureModuleStructureInspectorDialog(
          module: module,
        );
      },
    );
  }
}

class _DebugFeatureModuleStructureInspectorDialogState
    extends State<DebugFeatureModuleStructureInspectorDialog> {
  @override
  Widget build(BuildContext context) {
    Size preferContentSize = DialogSizeUtils.calculateDebugDialogSize(context);

    // Set up the AlertDialog
    dialogs.FaDialog alert = dialogs.FaDialog(
      iconData: FaIconConstants.moduleStructureIconData,
      titleText:
          "Debug Shelf Structure Inspector - ${getClassName(widget.module)}",
      contentPadding: const EdgeInsets.all(5),
      preferredContentWidth: preferContentSize.width,
      preferredContentHeight: preferContentSize.height,
      content: _buildMainContent(context),
      onHelpPressed: () {
        TipDocumentViewerDialog.show(
          context: context,
          tipDocument: TipDocument.debugShelfStructureInspector,
        );
      },
    );
    return alert;
  }

  Widget _buildMainContent(BuildContext context) {
    FeatureModule module = widget.module;
    if (module is Shelf) {
      return ShelfStructureGraphView(
        shelf: module,
        onPressedBack: null,
      );
    } else if (module is Activity) {
      return ActivityStructureGraphView(
        activity: module,
        onPressedBack: null,
      );
    } else {
      return Text("TODO: _buildMainContent");
    }
  }
}
