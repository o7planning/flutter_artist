import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';

class CopyUtils {
  static void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Copied to clipboard",
              style: TextStyle(color: context.faColors.action.ink.info),
            ),
            behavior: SnackBarBehavior.floating,
            width: 220,
            duration: const Duration(seconds: 1),
            backgroundColor: context.faColors.action.fill.info,
          ),
        );
      }
    });
  }
}
