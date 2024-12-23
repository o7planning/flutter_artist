part of '../flutter_artist.dart';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class _FormDataInfoDialog extends StatefulWidget {
  final BlockForm blockForm;
  final String locationInfo;

  const _FormDataInfoDialog({
    required this.blockForm,
    required this.locationInfo,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _FormDataInfoDialogState();
  }
}

class _FormDataInfoDialogState extends State<_FormDataInfoDialog> {
  bool showFormData = true;

  @override
  Widget build(BuildContext context) {
    Size size = _calculateDebugDialogSize(context);

    // Set up the AlertDialog
    AlertDialog alert = _CustomAlertDialog(
      titleText: showFormData
          ? "${getClassName(widget.blockForm)} - Form Data"
          : "${getClassName(widget.blockForm.block.frame)} - Structure",
      contentPadding: const EdgeInsets.all(5),
      content: _buildMainContent(
        context,
        size.width,
        size.height,
      ),
      closeDialog: () {
        Navigator.of(context).pop();
      },
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
              blockForm: widget.blockForm,
              locationInfo: widget.locationInfo,
              onPressedFlu: () {
                setState(() {
                  showFormData = false;
                });
              },
            )
          : _FrameStructureGraphView(
              frame: widget.blockForm.block.frame,
              onPressedBack: () {
                setState(() {
                  showFormData = true;
                });
              },
            ),
    );
  }
}

Future<void> _showFromDataInfoDialog({
  required BuildContext context,
  required String locationInfo,
  required BlockForm blockForm,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _FormDataInfoDialog(
        blockForm: blockForm,
        locationInfo: locationInfo,
      );
    },
  );
}
