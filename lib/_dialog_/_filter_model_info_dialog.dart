part of '../flutter_artist.dart';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class _FilterModelInfoDialog extends StatefulWidget {
  final FilterModel dataFilter;
  final String locationInfo;

  const _FilterModelInfoDialog({
    required this.dataFilter,
    required this.locationInfo,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _FilterModelInfoDialogState();
  }
}

class _FilterModelInfoDialogState extends State<_FilterModelInfoDialog> {
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
          ? _FilterModelDebugView(
              dataFilter: widget.dataFilter,
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

Future<void> _showFilterModelInfoDialog({
  required BuildContext context,
  required String locationInfo,
  required FilterModel dataFilter,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _FilterModelInfoDialog(
        dataFilter: dataFilter,
        locationInfo: locationInfo,
      );
    },
  );
}
