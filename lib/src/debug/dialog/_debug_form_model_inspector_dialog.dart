import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart'
    as dialogs;

import '../../core/_core_/core.dart';
import '../../core/enums/_enums.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/_class_utils.dart';
import '../feature_module/activity/_activity_structure_graph_view.dart';
import '../feature_module/shelf/_shelf_structure_graph_view.dart';
import '../form/_form_model_view.dart';
import '../utils/_dialog_size.dart';
import '_tip_document_viewer_dialog.dart';

class DebugFormModelInspectorDialog extends StatefulWidget {
  final BaseFormModel formModel;
  final String locationInfo;

  const DebugFormModelInspectorDialog({
    required this.formModel,
    required this.locationInfo,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _DebugFormModelInspectorDialogState();
  }

  static Future<void> show({
    required BuildContext context,
    required String locationInfo,
    required BaseFormModel formModel,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DebugFormModelInspectorDialog(
          formModel: formModel,
          locationInfo: locationInfo,
        );
      },
    );
  }
}

class _DebugFormModelInspectorDialogState
    extends State<DebugFormModelInspectorDialog> {
  bool showFormData = true;

  @override
  Widget build(BuildContext context) {
    final Size preferContentSize =
        DialogSizeUtils.calculateDebugDialogSize(context);

    // Set up the AlertDialog
    dialogs.FaDialog alert = dialogs.FaDialog(
      iconData: showFormData
          ? FaIconConstants.formModelIconData
          : FaIconConstants.moduleStructureIconData,
      titleText: showFormData
          ? "Debug Form Model Inspector - ${getClassName(widget.formModel)}"
          : "Debug Shelf Structure Inspector - ${getClassName(widget.formModel.module)}",
      contentPadding: const EdgeInsets.all(5),
      preferredContentWidth: preferContentSize.width,
      preferredContentHeight: preferContentSize.height,
      content: _buildMainContent(context),
      onHelpPressed: () {
        TipDocumentViewerDialog.show(
          context: context,
          tipDocument: TipDocument.debugFormModelInspector,
        );
      },
    );
    return alert;
  }

  Widget _buildMainContent(BuildContext context) {
    final FeatureModule module = widget.formModel.module;

    Widget moduleView;
    if (module is Shelf) {
      moduleView = ShelfStructureGraphView(
        shelf: module,
        onPressedBack: () {
          setState(() {
            showFormData = true;
          });
        },
      );
    } else if (module is Activity) {
      moduleView = ActivityStructureGraphView(
        activity: module,
        onPressedBack: () {
          setState(() {
            showFormData = true;
          });
        },
      );
    } else {
      moduleView = SizedBox();
    }

    return showFormData
        ? FormModelView(
            formModel: widget.formModel,
            locationInfo: widget.locationInfo,
            onPressedShelf: () {
              setState(() {
                showFormData = false;
              });
            },
          )
        : moduleView;
  }
}
