import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/icon/icon_constants.dart';
import '../../core/widgets/_simple_copy_button.dart';
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
    FaDialog alert = FaDialog(
      titleText: title,
      contentPadding: const EdgeInsets.all(5),
      preferredContentWidth: 320,
      preferredContentHeight: null,
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
    return Column(
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
          suffixIcon: SimpleCopyButton(
            iconSize: 14,
            getText: () {
              return locationInfo;
            },
          ),
        ),
      ],
    );
  }
}
