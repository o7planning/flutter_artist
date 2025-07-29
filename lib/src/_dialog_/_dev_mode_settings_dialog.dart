part of '../_fa_core.dart';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class _DevelopmentModeSettingsDialog extends StatefulWidget {
  final String title;
  final Shelf shelf;

  const _DevelopmentModeSettingsDialog({
    this.title = 'Development Mode Settings',
    required this.shelf,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _DevelopmentModeSettingsDialogState();
  }
}

class _DevelopmentModeSettingsDialogState
    extends State<_DevelopmentModeSettingsDialog> {
  static const double fontSize = 13;

  @override
  Widget build(BuildContext context) {
    // Set up the AlertDialog
    dialogs.FaAlertDialog alert = dialogs.FaAlertDialog(
      titleText: widget.title,
      contentPadding: const EdgeInsets.all(5),
      content: _buildMainContent(context),
      actions: [
        ElevatedButton(
          child: const Text(
            "Close",
            style: TextStyle(
              fontSize: _dialogButtonFontSize,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    return alert;
  }

  Widget _buildMainContent(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          CheckboxListTile(
            dense: true,
            visualDensity: const VisualDensity(vertical: -3, horizontal: -3),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: false,
            title: const Text(
              "Show Eager Loading Registers",
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
            onChanged: (bool? value) {
              //
            },
          ),
        ],
      ),
    );
  }

  void _saveSettings(BuildContext context) {
    //
  }
}

Future<void> _showDevelopmentSettingsDialog({
  required BuildContext context,
  required Shelf shelf,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _DevelopmentModeSettingsDialog(
        shelf: shelf,
      );
    },
  );
}
