import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core/code.dart';
import '../filter/_filter_data_debug_view.dart';
import '../storage/_shelf_structure_graph_view.dart';
import '../utils/_dialog_size.dart';

class FilterModelInfoDialog extends StatefulWidget {
  final FilterModel filterModel;
  final String locationInfo;

  const FilterModelInfoDialog({
    required this.filterModel,
    required this.locationInfo,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _FilterModelInfoDialogState();
  }

  static Future<void> showFilterModelInfoDialog({
    required BuildContext context,
    required String locationInfo,
    required FilterModel filterModel,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterModelInfoDialog(
          filterModel: filterModel,
          locationInfo: locationInfo,
        );
      },
    );
  }
}

class _FilterModelInfoDialogState extends State<FilterModelInfoDialog> {
  bool showFormData = true;

  @override
  Widget build(BuildContext context) {
    Size size = DialogSizeUtils.calculateDebugDialogSize(context);

    // Set up the AlertDialog
    FaAlertDialog alert = FaAlertDialog(
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
          ? FilterDataDebugView(
              filterModel: widget.filterModel,
              onPressedShelf: () {
                setState(() {
                  showFormData = false;
                });
              },
            )
          : ShelfStructureGraphView(
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
