import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart'
as dialogs;

import '../../core/_fa_core.dart';
import '../_debug_/_form_data_debug_view.dart';
import '../_debug_/_shelf_structure_graph_view.dart';
import '../_dialog_size.dart';

class FormDataInfoDialog extends StatefulWidget {
  final FormModel formModel;
  final String locationInfo;

  const FormDataInfoDialog({
    required this.formModel,
    required this.locationInfo,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _FormDataInfoDialogState();
  }

  static Future<void> showFormInfoDialog({
    required BuildContext context,
    required String locationInfo,
    required FormModel formModel,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return FormDataInfoDialog(
          formModel: formModel,
          locationInfo: locationInfo,
        );
      },
    );
  }
}

class _FormDataInfoDialogState extends State<FormDataInfoDialog> {
  bool showFormData = true;

  @override
  Widget build(BuildContext context) {
    Size size = DialogSizeUtils.calculateDebugDialogSize(context);

    // Set up the AlertDialog
    dialogs.FaAlertDialog alert = dialogs.FaAlertDialog(
      titleText: showFormData
          ? "${getClassName(widget.formModel)} - Form Data"
          : "${getClassName(widget.formModel.block.shelf)} - Structure",
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
      child: showFormData
          ? FormDataView(
              formModel: widget.formModel,
              locationInfo: widget.locationInfo,
              onPressedShelf: () {
                setState(() {
                  showFormData = false;
                });
              },
            )
          : ShelfStructureGraphView(
              shelf: widget.formModel.block.shelf,
              onPressedBack: () {
                setState(() {
                  showFormData = true;
                });
              },
            ),
    );
  }
}
