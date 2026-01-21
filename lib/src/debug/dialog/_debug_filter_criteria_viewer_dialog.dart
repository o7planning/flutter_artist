import 'package:flutter/material.dart';
import 'package:flutter_artist/src/debug/dialog/_tip_document_viewer_dialog.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_tip_document.dart';
import '../../core/icon/icon_constants.dart';
import '../filter/__filter_criteria_debug_view.dart';
import '../utils/_dialog_size.dart';

class DebugFilterCriteriaViewerDialog extends StatefulWidget {
  final FilterModel? filterModel;
  final Scalar? scalar;
  final Block? block;

  const DebugFilterCriteriaViewerDialog.block({
    required Block this.block,
    super.key,
  })  : scalar = null,
        filterModel = null;

  const DebugFilterCriteriaViewerDialog.scalar({
    required Scalar this.scalar,
    super.key,
  })  : block = null,
        filterModel = null;

  const DebugFilterCriteriaViewerDialog.filterModel({
    required FilterModel this.filterModel,
    super.key,
  })  : block = null,
        scalar = null;

  @override
  State<StatefulWidget> createState() {
    return _DebugFilterCriteriaViewerDialogState();
  }

  static Future<void> showFilterCriteriaViewerDialog({
    required BuildContext context,
    required FilterModel filterModel,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DebugFilterCriteriaViewerDialog.filterModel(
          filterModel: filterModel,
        );
      },
    );
  }

  static Future<void> showBlockFilterCriteriaDialog({
    required BuildContext context,
    required Block block,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DebugFilterCriteriaViewerDialog.block(
          block: block,
        );
      },
    );
  }

  static Future<void> showScalarFilterCriteriaDialog({
    required BuildContext context,
    required Scalar scalar,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DebugFilterCriteriaViewerDialog.scalar(
          scalar: scalar,
        );
      },
    );
  }
}

class _DebugFilterCriteriaViewerDialogState
    extends State<DebugFilterCriteriaViewerDialog> {
  static const double fontSize = 13;

  String _title() {
    return "Debug Filter Criteria Viewer";
  }

  @override
  Widget build(BuildContext context) {
    FaAlertDialog alert = FaAlertDialog(
      icon: Icon(
        FaIconConstants.filterCriteriaDebugIconData,
        size: 16,
      ),
      titleText: _title(),
      contentPadding: const EdgeInsets.all(5),
      content: _buildMainContent(context),
      onHelpPressed: () {
        TipDocumentViewerDialog.open(
          context: context,
          tipDocument: TipDocument.debugFilterCriteriaViewer,
        );
      },
    );
    return alert;
  }

  Widget _buildMainContent(BuildContext context) {
    final preferSize = DialogSizeUtils.calculateDebugDialogSize(context);
    //
    Widget child;
    if (widget.block != null) {
      child = FilterCriteriaDebugView.block(block: widget.block!);
    } else if (widget.scalar != null) {
      child = FilterCriteriaDebugView.scalar(scalar: widget.scalar!);
    } else if (widget.filterModel != null) {
      child = FilterCriteriaDebugView.filterModel(
        filterModel: widget.filterModel!,
      );
    } else {
      child = Center(
        child: Text("TODO"),
      );
    }
    return SizedBox(
      width: preferSize.width,
      height: preferSize.height,
      child: child,
    );
  }
}
