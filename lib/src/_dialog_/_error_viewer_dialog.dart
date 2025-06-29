part of '../../flutter_artist.dart';

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

    dialogs.FaAlertDialog alert = dialogs.FaAlertDialog(
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
}

Future<void> _showErrorViewerDialog({
  required BuildContext context,
  required String title,
  required dynamic error,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleErrorViewerDialog(
        title: title,
        error: error,
      );
    },
  );
}
