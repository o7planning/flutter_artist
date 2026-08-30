import 'package:flutter/material.dart';

class CodeFlowConstants {
  static Color getSelectedBg(BuildContext context) =>
      Theme.of(context).colorScheme.primary.withValues(alpha: 0.15);

  static Color getDeselectedBg(BuildContext context) {
    final theme = Theme.of(context);
    return theme.brightness == Brightness.dark
        ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
        : Colors.grey.withValues(alpha: 0.1);
  }

  static Color getMainIconColor(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  // Tạm thời đưa trở lại:
  static final Color devCodeIconColor = Colors.indigo;
  static final Color libPublicCodeIconColor = Colors.black;
  static final Color libPrivateCodeIconColor = Colors.grey;
}

TextStyle codeStyle(BuildContext context, {bool isBold = false}) {
  return TextStyle(
    fontFamily: 'Courier',
    fontSize: 12,
    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    color: Theme.of(context).colorScheme.onSurfaceVariant,
  );
}
