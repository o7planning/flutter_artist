part of '../flutter_artist.dart';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
enum _DialogType {
  confirmation,
  message,
}

class _ConfirmDialog extends StatelessWidget {
  final _DialogType type;
  final String title;
  final String message;
  final String? content;

  const _ConfirmDialog({
    required this.type,
    this.title = 'Confirm',
    required this.message,
    this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const double WIDTH = 320;

    var msgWidget = SizedBox(
      width: WIDTH,
      child: Text(
        message,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
    );
    Widget contentWidget = msgWidget;
    if (content != null) {
      contentWidget = SizedBox(
        width: WIDTH,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            msgWidget,
            const SizedBox(height: 10),
            Text(
              content!,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: const TextStyle(
                color: Colors.blueGrey,
              ),
            )
          ],
        ),
      );
    }

    // set up the AlertDialog
    AlertDialog alert = _CustomAlertDialog(
      titleText: title,
      content: contentWidget,
      closeDialog: () {
        Navigator.of(context).pop(false);
      },
      actions: [
        if (type == _DialogType.confirmation)
          ElevatedButton(
            child: const Text("Yes"),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        if (type == _DialogType.confirmation)
          ElevatedButton(
            child: const Text("No"),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
      ],
    );
    return alert;
  }
}

Future<void> _showMessageDialog({
  required BuildContext context,
  required String message,
  required String? details,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _ConfirmDialog(
        type: _DialogType.message,
        title: "Message",
        message: message,
        content: details,
      );
    },
  );
}

Future<bool> _showConfirmDialog({
  required BuildContext context,
  required String message,
  required String details,
}) async {
  bool? confirm = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _ConfirmDialog(
        type: _DialogType.confirmation,
        title: "Confirmation",
        message: message,
        content: details,
      );
    },
  );
  return confirm ?? false;
}

Future<bool> _showConfirmDeleteDialog({
  required BuildContext context,
  required String details,
}) async {
  return await _showConfirmDialog(
    context: context,
    message: "Are you sure to delete this record?",
    details: details,
  );
}
