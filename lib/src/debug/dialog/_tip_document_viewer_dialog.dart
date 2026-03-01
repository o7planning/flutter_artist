import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/enums/_tip_document.dart';
import '../../core/icon/icon_constants.dart';

class TipDocumentViewerDialog extends StatefulWidget {
  final TipDocument tipDocument;

  const TipDocumentViewerDialog({
    required this.tipDocument,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _TipDocumentViewerDialogState();
  }

  static Future<void> open({
    required BuildContext context,
    required TipDocument tipDocument,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return TipDocumentViewerDialog(
          tipDocument: tipDocument,
        );
      },
    );
  }
}

class _TipDocumentViewerDialogState extends State<TipDocumentViewerDialog> {
  late TipDocument tipDocument;

  @override
  void initState() {
    super.initState();
    tipDocument = widget.tipDocument;
  }

  @override
  Widget build(BuildContext context) {
    Size preferredSize = calculatePreferredDialogSize(
      context,
      preferredWidth: 620,
      preferredHeight: 320,
    );
    FaAlertDialog alert = FaAlertDialog(
      icon: Icon(
        FaIconConstants.tipDocument,
        color: Colors.deepOrange,
        size: 16,
      ),
      titleText: "Tip & Docs - ${tipDocument.getTitle()}",
      contentPadding: EdgeInsets.all(8),
      content: SizedBox(
        width: preferredSize.width,
        height: preferredSize.height,
        child: _buildMainContent(context),
      ),
    );
    return alert;
  }

  Widget _buildMainContent(BuildContext context) {
    final documentWidget = _buildDocument(context);
    return Padding(
      padding: EdgeInsets.all(3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildControlBar(),
          SizedBox(height: 5),
          Expanded(
            child: _buildTip(),
          ),
          if (documentWidget != null) SizedBox(height: 10),
          if (documentWidget != null) documentWidget,
        ],
      ),
    );
  }

  Widget _buildControlBar() {
    return SizedBox(
      width: double.maxFinite,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 3, 3, 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "${tipDocument.getPosition()} / ${TipDocument.enabledValues.length}",
                style: TextStyle(fontSize: 12),
              ),
              Spacer(),
              SimpleSmallIconButton(
                iconData: Icons.arrow_circle_left_outlined,
                iconSize: 14,
                onPressed: () {
                  setState(() {
                    tipDocument = tipDocument.previous();
                  });
                },
              ),
              SimpleSmallIconButton(
                iconData: Icons.arrow_circle_right_outlined,
                iconSize: 14,
                onPressed: () {
                  setState(() {
                    tipDocument = tipDocument.next();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTip() {
    return SizedBox(
      width: double.maxFinite,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: SelectableText(
            tipDocument.getTip(),
            style: TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }

  Widget? _buildDocument(BuildContext context) {
    List<String> docs = tipDocument.getDocuments();
    if (docs.isEmpty) {
      return null;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: docs
          .map((doc) => _buildLink(context, doc))
          .expand((w) => [w, SizedBox(height: 5)])
          .toList()
        ..removeLast(),
    );
  }

  Widget _buildLink(BuildContext context, String url) {
    return SelectableText.rich(
      style: TextStyle(fontSize: 13, color: Colors.indigo),
      TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              Icons.arrow_circle_right_outlined,
              size: 14,
            ),
            alignment: PlaceholderAlignment.middle,
          ),
          const WidgetSpan(child: SizedBox(width: 2)),
          TextSpan(text: url),
          const TextSpan(text: ' '),
          WidgetSpan(
            child: SimpleSmallIconButton(
              iconData: Icons.open_in_new,
              iconSize: 14,
              onPressed: () async {
                var urlObj = Uri.parse(url);
                await launchUrl(urlObj);
              },
            ),
            alignment: PlaceholderAlignment.middle,
          ),
          const WidgetSpan(child: SizedBox(width: 2)),
          WidgetSpan(
            child: SimpleSmallIconButton(
              iconData: Icons.copy_rounded,
              iconSize: 14,
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: url));
                // Optionally, show a SnackBar or other feedback to the user
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied!')),
                );
              },
            ),
            alignment: PlaceholderAlignment.middle,
          ),
        ],
      ),
    );
  }
}
