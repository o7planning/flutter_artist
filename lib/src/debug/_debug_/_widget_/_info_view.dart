import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../icon/icon_constants.dart';

class InfoView extends StatelessWidget {
  final String info;

  const InfoView({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: IconLabelText(
        icon: const Icon(
          FaIconConstants.infoIconData,
          size: 16,
        ),
        label: "",
        text: info,
        style: const TextStyle(
          fontSize: 13,
        ),
      ),
    );
  }
}
