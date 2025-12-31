import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/widgets/_html_selectable_rich_text.dart';

class ExtraInfoViewerDialog extends StatelessWidget {
  final String title;
  final List<String> extraInfos;

  const ExtraInfoViewerDialog({
    required this.title,
    required this.extraInfos,
    super.key,
  });

  String _getExtraInfoText() {
    int i = 1;
    return extraInfos
        .map((s) => "${(i++).toString().padLeft(3, '0')} - $s")
        .join("\n");
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
        Icons.info_outline,
        size: 18,
        color: Colors.indigo,
      ),
      titleText: title,
      contentPadding: EdgeInsets.all(8),
      content: SizedBox(
        width: preferredSize.width,
        height: preferredSize.height,
        child: Expanded(
          child: Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: HtmlSelectableRichText(
                _getExtraInfoText(),
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
      ),
    );
    return alert;
  }

  static Future<void> open({
    required BuildContext context,
    required String title,
    required List<String> extraInfos,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ExtraInfoViewerDialog(
          title: title,
          extraInfos: extraInfos,
        );
      },
    );
  }
}
