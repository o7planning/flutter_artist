part of '../flutter_artist.dart';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class _DataFilterInfoDialog extends StatefulWidget {
  final DataFilter dataFilter;
  final String locationInfo;

  const _DataFilterInfoDialog({
    required this.dataFilter,
    required this.locationInfo,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return __DataFilterInfoDialogState();
  }
}

class __DataFilterInfoDialogState extends State<_DataFilterInfoDialog> {
  bool showFormData = true;

  @override
  Widget build(BuildContext context) {
    Size size = _calculateDebugDialogSize(context);

    // Set up the AlertDialog
    dialogs.CustomAlertDialog alert = dialogs.CustomAlertDialog(
      titleText: showFormData
          ? "${getClassName(widget.dataFilter)} - Data Filter"
          : "${getClassName(widget.dataFilter.shelf)} - Structure",
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
          ? _DataFilterDebugView(
              dataFilter: widget.dataFilter,
              locationInfo: widget.locationInfo,
              onPressedShelf: () {
                setState(() {
                  showFormData = false;
                });
              },
            )
          : _ShelfStructureGraphView(
              shelf: widget.dataFilter.shelf,
              onPressedBack: () {
                setState(() {
                  showFormData = true;
                });
              },
            ),
    );
  }
}

Future<void> _showDataFilterInfoDialog({
  required BuildContext context,
  required String locationInfo,
  required DataFilter dataFilter,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _DataFilterInfoDialog(
        dataFilter: dataFilter,
        locationInfo: locationInfo,
      );
    },
  );
}
