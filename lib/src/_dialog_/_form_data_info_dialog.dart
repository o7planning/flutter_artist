part of '../../flutter_artist.dart';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class _FormDataInfoDialog extends StatefulWidget {
  final FormModel formModel;
  final String locationInfo;

  const _FormDataInfoDialog({
    required this.formModel,
    required this.locationInfo,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return __FormDataInfoDialogState();
  }
}

class __FormDataInfoDialogState extends State<_FormDataInfoDialog> {
  bool showFormData = true;

  @override
  Widget build(BuildContext context) {
    Size size = _calculateDebugDialogSize(context);

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
          ? _FormDataView(
              formModel: widget.formModel,
              locationInfo: widget.locationInfo,
              onPressedShelf: () {
                setState(() {
                  showFormData = false;
                });
              },
            )
          : _ShelfStructureGraphView(
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

Future<void> _showFormInfoDialog({
  required BuildContext context,
  required String locationInfo,
  required FormModel formModel,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _FormDataInfoDialog(
        formModel: formModel,
        locationInfo: locationInfo,
      );
    },
  );
}
