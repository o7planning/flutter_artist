import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:url_launcher/url_launcher.dart';

class SimpleOpenUrlButton extends StatelessWidget {
  final String? tooltip;
  final double iconSize;
  final String url;

  const SimpleOpenUrlButton({
    super.key,
    required this.url,
    this.iconSize = 18,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleSmallIconButton(
      iconData: Icons.open_in_new_rounded,
      iconSize: iconSize,
      iconColor: context.faColors.ink.label,
      onPressed: () async {
        await launchUrl(Uri.parse(url));
      },
    );
  }
}
