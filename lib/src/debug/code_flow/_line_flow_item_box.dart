import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../../core/widgets/_html_selectable_rich_text.dart';
import '../dialog/_error_viewer_dialog.dart';

class LineFlowItemBox extends StatelessWidget {
  final LineFlowItem lineFlowItem;

  const LineFlowItemBox({
    required this.lineFlowItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        margin: EdgeInsets.all(2),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              HtmlSelectableRichText(
                lineFlowItem.shortDesc,
                icon: Icon(
                  lineFlowItem.lineFlowType.getIconData(),
                  color: lineFlowItem.lineFlowType.getIconColor(),
                  size: 16,
                ),
                label: lineFlowItem.lineId,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
                tagStyles: {
                  'b': TextStyle(fontWeight: FontWeight.bold),
                  'i': TextStyle(fontStyle: FontStyle.italic),
                },
                style: TextStyle(fontSize: 12),
              ),
              // IconLabelSelectableText(
              //   icon: Icon(
              //     lineFlowItem.lineFlowType.getIconData(),
              //     color: lineFlowItem.lineFlowType.getIconColor(),
              //     size: 16,
              //   ),
              //   label: lineFlowItem.lineId,
              //   text: lineFlowItem.shortDesc,
              //   labelStyle: TextStyle(
              //     fontSize: 12,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.indigo,
              //   ),
              //   textStyle: TextStyle(fontSize: 12),
              // ),
              if (lineFlowItem.errorInfo != null ||
                  lineFlowItem.tipDocument != null)
                SizedBox(height: 5),
              if (lineFlowItem.errorInfo != null ||
                  lineFlowItem.tipDocument != null)
                _buildControlBar(context),
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
        SimpleSmallIconButton(
          iconData: Icons.error_outline_rounded,
          iconColor: lineFlowItem.errorInfo == null ? null : Colors.red,
          onPressed: lineFlowItem.errorInfo == null
              ? null
              : () {
                  _showErrorDialog(context);
                },
        ),
        SimpleSmallIconButton(
            iconData: Icons.playlist_add_check_circle_outlined),
        SimpleSmallIconButton(
          iconData: Icons.account_balance_wallet_outlined,
          onPressed: lineFlowItem.tipDocument == null
              ? null
              : () {
                  _showTipDocumentDialog(context);
                },
        ),
      ],
    );
  }

  void _showErrorDialog(BuildContext context) {
    if (lineFlowItem.errorInfo != null) {
      ErrorViewerDialog.showErrorViewerDialog(
        context: context,
        title: "Error Viewer",
        errorInfo: lineFlowItem.errorInfo!,
      );
    }
  }

  void _showTipDocumentDialog(BuildContext context) {
    if (lineFlowItem.tipDocument != null) {
      // ErrorViewerDialog.showErrorViewerDialog(
      //   context: context,
      //   title: "Error Viewer",
      //   errorInfo: lineFlowItem.errorInfo!,
      // );
    }
  }
}
