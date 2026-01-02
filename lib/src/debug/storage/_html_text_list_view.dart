import 'package:flutter/material.dart';
import 'package:flutter_artist/src/core/icon/icon_constants.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/enums/_tip_document.dart';
import '../../core/widgets/_html_selectable_rich_text.dart';
import '../dialog/_tip_document_viewer_dialog.dart';

class HtmlTextListView extends StatefulWidget {
  final List<String> htmlTexts;
  final TipDocument? tipDocument;

  const HtmlTextListView({
    super.key,
    required this.htmlTexts,
    required this.tipDocument,
  });

  @override
  State<StatefulWidget> createState() {
    return _HtmlTextListViewState();
  }
}

class _HtmlTextListViewState extends State<HtmlTextListView> {
  @override
  Widget build(BuildContext context) {
    List<String> list = widget.htmlTexts..sort();
    //
    return Stack(
      children: [
        Container(
          width: double.maxFinite,
          height: double.maxFinite,
          padding: EdgeInsets.all(5),
          child: Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: HtmlSelectableRichText(
                _getExtraInfoText(list),
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                tagStyles: {
                  'b': TextStyle(fontWeight: FontWeight.bold),
                  'i': TextStyle(fontStyle: FontStyle.italic),
                },
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: SimpleSmallIconButton(
            iconData: FaIconConstants.tipDocument,
            iconSize: 14,
            iconColor: widget.tipDocument == null ? null : Colors.deepOrange,
            onPressed: widget.tipDocument == null
                ? null
                : () {
                    TipDocumentViewerDialog.open(
                      context: context,
                      tipDocument: widget.tipDocument!,
                    );
                  },
          ),
        ),
      ],
    );
  }

  String _getExtraInfoText(List<String> list) {
    int i = 1;
    return list
        .map((s) => "${(i++).toString().padLeft(3, '0')} - $s")
        .join("\n");
  }
}
