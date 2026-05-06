import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_tip_document.dart';
import '../../core/icon/icon_constants.dart';
import '../filter/_debug_filter_criteria_view.dart';
import '../filter/_debug_filter_model_view.dart';
import '../filter/_filter_dialog_enum.dart';
import '../shelf/_shelf_structure_graph_view.dart';
import '../utils/_dialog_size.dart';
import '_tip_document_viewer_dialog.dart';

class DebugViewerDialog extends StatefulWidget {
  final FilterViewType filterViewType;
  final FilterModel filterModel;
  final String locationInfo;

  const DebugViewerDialog({
    required this.filterViewType,
    required this.filterModel,
    required this.locationInfo,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _DebugViewerDialogState();
  }

  static Future<void> openDebugFilterModelViewer({
    required BuildContext context,
    required String locationInfo,
    required FilterModel filterModel,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DebugViewerDialog(
          filterViewType: FilterViewType.debugFilterModel,
          filterModel: filterModel,
          locationInfo: locationInfo,
        );
      },
    );
  }

  static Future<void> openDebugFilterCriteriaInspector({
    required BuildContext context,
    required String locationInfo,
    required FilterModel filterModel,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DebugViewerDialog(
          filterViewType: FilterViewType.debugFilterCriteria,
          filterModel: filterModel,
          locationInfo: locationInfo,
        );
      },
    );
  }
}

class _DebugViewerDialogState extends State<DebugViewerDialog> {
  late FilterViewType filterViewType;

  @override
  void initState() {
    super.initState();
    filterViewType = widget.filterViewType;
  }

  @override
  Widget build(BuildContext context) {
    Size preferContentSize = DialogSizeUtils.calculateDebugDialogSize(context);

    // Set up the AlertDialog
    FaDialog alert = FaDialog(
      iconData: FaIconConstants.filterModelDebugIconData,
      titleText: filterViewType.title,
      contentPadding: const EdgeInsets.all(5),
      preferredContentWidth: preferContentSize.width,
      preferredContentHeight: preferContentSize.height,
      content: _buildMainContent(context),
      onHelpPressed: _onHelpPressed,
    );
    return alert;
  }

  void _onHelpPressed() {
    TipDocument tipDocument;
    switch (filterViewType) {
      case FilterViewType.debugFilterModel:
        tipDocument = TipDocument.debugFilterModelInspector;
      case FilterViewType.debugFilterCriteria:
        tipDocument = TipDocument.debugFilterCriteriaInspector;
      case FilterViewType.debugShelfStructure:
        tipDocument = TipDocument.debugShelfStructureInspector;
    }
    TipDocumentViewerDialog.show(
      context: context,
      tipDocument: tipDocument,
    );
  }

  Widget _buildMainContent(BuildContext context) {
    Widget mainWidget;
    switch (filterViewType) {
      case FilterViewType.debugFilterModel:
        mainWidget = DebugFilterModelView(
          filterModel: widget.filterModel,
          onPressedShelfStructure: () {
            setState(() {
              filterViewType = FilterViewType.debugShelfStructure;
            });
          },
          onPressedFilterCriteria: () {
            setState(() {
              filterViewType = FilterViewType.debugFilterCriteria;
            });
          },
        );
      case FilterViewType.debugFilterCriteria:
        mainWidget = DebugFilterCriteriaView.filterModel(
          filterModel: widget.filterModel,
          onDebugFilterModelPressed: () {
            setState(() {
              filterViewType = FilterViewType.debugFilterModel;
            });
          },
        );
      case FilterViewType.debugShelfStructure:
        mainWidget = ShelfStructureGraphView(
          shelf: widget.filterModel.shelf,
          onPressedBack: () {
            setState(() {
              filterViewType = FilterViewType.debugFilterModel;
            });
          },
        );
    }
    return mainWidget;
  }
}
