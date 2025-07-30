import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/icon/icon_constants.dart';
import '_dialog_constants.dart';

class LocationInfoDialog extends StatelessWidget {
  final String title;
  final String locationInfo;

  const LocationInfoDialog({
    this.title = 'Location',
    required this.locationInfo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Set up the AlertDialog
    FaAlertDialog alert = FaAlertDialog(
      titleText: title,
      contentPadding: const EdgeInsets.all(5),
      content: _buildMainContent(context),
      actions: [
        ElevatedButton(
          child: Text(
            "Close",
            style: TextStyle(
              fontSize: DialogConstants.dialogButtonFontSize,
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
          IconLabelText(
            icon: Icon(
              FaIconConstants.locationIconData,
              size: 18,
              color: Colors.black54,
            ),
            label: "Location: ",
            text: locationInfo,
            suffixIcon: SimpleSmallIconButton(
              iconData: FaIconConstants.copyToClipboardIconData,
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
      return LocationInfoDialog(
        locationInfo: locationInfo,
      );
    },
  );
}
