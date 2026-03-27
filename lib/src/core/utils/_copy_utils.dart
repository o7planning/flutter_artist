import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

class CopyUtils {
  static void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Copied to clipboard"),
            behavior: SnackBarBehavior.floating,
            width: 220,
            duration: const Duration(seconds: 1),
            backgroundColor: FaColorUtils.primaryHighlight(context),
          ),
        );
      }
    });
  }
}
