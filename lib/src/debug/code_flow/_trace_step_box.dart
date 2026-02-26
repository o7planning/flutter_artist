import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_trace_step_type.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/widgets/_html_selectable_rich_text.dart';
import '../dialog/_error_viewer_dialog.dart';
import '../dialog/_extra_info_viewer_dialog.dart';
import '../dialog/_tip_document_viewer_dialog.dart';

class TraceStepBox extends StatelessWidget {
  final TraceStep traceStep;

  const TraceStepBox({
    required this.traceStep,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (traceStep.lineFlowType == LineFlowType.separator) {
      return SizedBox(
        width: double.maxFinite,
        child: Card(
          color: Colors.lightBlueAccent,
          margin: EdgeInsets.symmetric(vertical: 2),
          child: SizedBox(height: 3),
        ),
      );
    }
    return SizedBox(
      width: double.maxFinite,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        margin: EdgeInsets.symmetric(vertical: 2),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              HtmlSelectableRichText(
                "${traceStep.shortDesc}${traceStep.getParametersAsHtmlString()}"
                "${traceStep.getActionableAsHtmlString()}${traceStep.getNoteAsHtmlString()}",
                icon: Icon(
                  traceStep.lineFlowType.getIconData(),
                  color: traceStep.showIconAndLabel
                      ? traceStep.lineFlowType.getIconColor()
                      : Colors.transparent,
                  size: 16,
                ),
                label: traceStep.lineId,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: traceStep.showIconAndLabel
                      ? Colors.indigo
                      : Colors.transparent,
                ),
                tagStyles: {
                  'b': TextStyle(fontWeight: FontWeight.bold),
                  'i': TextStyle(fontStyle: FontStyle.italic),
                },
                style: TextStyle(fontSize: 12),
              ),
              if (traceStep.needControlBar()) SizedBox(height: 5),
              if (traceStep.needControlBar()) _buildControlBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlBar(BuildContext context) {
    return Wrap(
      spacing: 0,
      children: [
        Tooltip(
          message: "Error Info",
          child: SimpleSmallIconButton(
            iconData: Icons.error_outline_rounded,
            iconColor: traceStep.errorInfo == null ? null : Colors.red,
            onPressed: traceStep.errorInfo == null
                ? null
                : () {
                    _showErrorDialog(context);
                  },
          ),
        ),
        Tooltip(
          message: "Extra Info",
          child: SimpleSmallIconButton(
            iconData: Icons.playlist_add_check_circle_outlined,
            onPressed: traceStep.hasExtraInfos()
                ? () {
                    _showExtraInfoDialog(context);
                  }
                : null,
          ),
        ),
        Tooltip(
          message: "Tip & Document",
          child: SimpleSmallIconButton(
            iconData: FaIconConstants.tipDocument,
            iconColor: traceStep.tipDocument == null //
                ? null
                : Colors.deepOrange,
            onPressed:
                traceStep.tipDocument == null || !traceStep.tipDocument!.enabled
                    ? null
                    : () {
                        _showTipDocumentDialog(context);
                      },
          ),
        ),
      ],
    );
  }

  void _showExtraInfoDialog(BuildContext context) {
    ExtraInfoViewerDialog.open(
      context: context,
      title: "Extra Info",
      extraInfos: traceStep.extraInfos ?? [],
    );
  }

  void _showErrorDialog(BuildContext context) {
    if (traceStep.errorInfo != null) {
      ErrorViewerDialog.open(
        context: context,
        title: "Error Viewer",
        errorInfo: traceStep.errorInfo!,
      );
    }
  }

  void _showTipDocumentDialog(BuildContext context) {
    if (traceStep.tipDocument != null) {
      TipDocumentViewerDialog.open(
        context: context,
        tipDocument: traceStep.tipDocument!,
      );
    }
  }
}
