part of '../flutter_artist.dart';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class _LocationInfoDialog extends StatelessWidget {
  final String title;
  final String locationInfo;

  const _LocationInfoDialog({
    this.title = 'Location',
    required this.locationInfo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Set up the AlertDialog
    AlertDialog alert = _CustomAlertDialog(
      titleText: title,
      contentPadding: const EdgeInsets.all(5),
      content: _buildMainContent(context),
      closeDialog: () {
        Navigator.of(context).pop();
      },
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
          _IconLabelText(
            icon: const Icon(
              _locationIconData,
              size: 18,
              color: Colors.black54,
            ),
            label: "Location: ",
            text: locationInfo,
            suffixIcon: _SimpleSmallIconButton(
              iconData: _copyToClipboardIconData,
              iconSize: 14,
              iconColor: Colors.black54,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: locationInfo));
                var snackBar = const SnackBar(content: Text("Copied!"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _showLocationInfoDialog({
  required BuildContext context,
  required String locationInfo,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _LocationInfoDialog(
        locationInfo: locationInfo,
      );
    },
  );
}
