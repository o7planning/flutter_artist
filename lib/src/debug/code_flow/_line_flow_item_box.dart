import 'package:flutter/material.dart';
import 'package:flutter_artist/src/core/icon/icon_constants.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_line_flow_type.dart';
import '../../core/widgets/_html_selectable_rich_text.dart';
import '../dialog/_error_viewer_dialog.dart';
import '../dialog/_extra_info_viewer_dialog.dart';
import '../dialog/_tip_document_viewer_dialog.dart';

class LineFlowItemBox extends StatelessWidget {
  final LineFlowItem lineFlowItem;

  const LineFlowItemBox({
    required this.lineFlowItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (lineFlowItem.lineFlowType == LineFlowType.separator) {
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
                "${lineFlowItem.shortDesc}${lineFlowItem.getParametersAsHtmlString()}"
                "${lineFlowItem.getActionableAsHtmlString()}${lineFlowItem.getNoteAsHtmlString()}",
                icon: Icon(
                  lineFlowItem.lineFlowType.getIconData(),
                  color: lineFlowItem.showIconAndLabel
                      ? lineFlowItem.lineFlowType.getIconColor()
                      : Colors.transparent,
                  size: 16,
                ),
                label: lineFlowItem.lineId,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: lineFlowItem.showIconAndLabel
                      ? Colors.indigo
                      : Colors.transparent,
                ),
                tagStyles: {
                  'b': TextStyle(fontWeight: FontWeight.bold),
                  'i': TextStyle(fontStyle: FontStyle.italic),
                },
                style: TextStyle(fontSize: 12),
              ),
              if (lineFlowItem.needControlBar()) SizedBox(height: 5),
              if (lineFlowItem.needControlBar()) _buildControlBar(context),
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
            iconColor: lineFlowItem.errorInfo == null ? null : Colors.red,
            onPressed: lineFlowItem.errorInfo == null
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
            onPressed: lineFlowItem.hasExtraInfos()
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
            iconColor: lineFlowItem.tipDocument == null //
                ? null
                : Colors.deepOrange,
            onPressed: lineFlowItem.tipDocument == null ||
                    !lineFlowItem.tipDocument!.enabled
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
      extraInfos: lineFlowItem.extraInfos ?? [],
    );
  }

  void _showErrorDialog(BuildContext context) {
    if (lineFlowItem.errorInfo != null) {
      ErrorViewerDialog.open(
        context: context,
        title: "Error Viewer",
        errorInfo: lineFlowItem.errorInfo!,
      );
    }
  }

  void _showTipDocumentDialog(BuildContext context) {
    if (lineFlowItem.tipDocument != null) {
      TipDocumentViewerDialog.open(
        context: context,
        tipDocument: lineFlowItem.tipDocument!,
      );
    }
  }
}
