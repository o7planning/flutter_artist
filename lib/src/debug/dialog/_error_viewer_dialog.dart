import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../section/_error_info_viewer.dart';

class ErrorViewerDialog extends StatelessWidget {
  final String title;
  final ErrorInfo errorInfo;

  const ErrorViewerDialog({
    required this.title,
    required this.errorInfo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size preferredSize = calculatePreferredDialogSize(
      context,
      preferredWidth: 620,
      preferredHeight: 400,
    );

    FaAlertDialog alert = FaAlertDialog(
      titleText: title,
      contentPadding: EdgeInsets.all(8),
      content: ErrorInfoView(
        errorInfo: errorInfo,
        width: preferredSize.width,
        height: preferredSize.height,
      ),
    );
    return alert;
  }

  static Future<void> open({
    required BuildContext context,
    required String title,
    required ErrorInfo errorInfo,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorViewerDialog(
          title: title,
          errorInfo: errorInfo,
        );
      },
    );
  }
}
