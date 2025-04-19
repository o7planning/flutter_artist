part of '../flutter_artist.dart';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class _FilterModelInfoDialog extends StatefulWidget {
  final FilterModel filterModel;
  final String locationInfo;

  const _FilterModelInfoDialog({
    required this.filterModel,
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
          ? "${getClassName(widget.filterModel)} - Filter Model"
          : "${getClassName(widget.filterModel.shelf)} - Structure",
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
          ? _FilterDataDebugView(
              filterModel: widget.filterModel,
              onPressedShelf: () {
                setState(() {
                  showFormData = false;
                });
              },
            )
          : _ShelfStructureGraphView(
              shelf: widget.filterModel.shelf,
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
  required FilterModel filterModel,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _FilterModelInfoDialog(
        filterModel: filterModel,
        locationInfo: locationInfo,
      );
    },
  );
}
