import 'package:flutter/material.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';

class SortPanelHelper {
  static Color getTextColor(BuildContext context, bool isActive) {
    return isActive
        ? context.faColors.ink.primary
        : context.faColors.ink.secondary;
  }

  static Color getSortIconColor(BuildContext context, bool isActive) {
    return isActive
        ? context.faColors.ink.primary
        : context.faColors.ink.secondary;
  }

  static Color getIconColor(BuildContext context, bool isActive) {
    return isActive
        ? context.faColors.ink.primary
        : context.faColors.ink.secondary;
  }

  static Color getBackgroundColor(BuildContext context) {
    return context.faColors.surface.subtle;
  }

  static BorderSide getBorder(BuildContext context) {
    return BorderSide(
      color: context.faColors.stroke.subtle,
      width: 1,
    );
  }

  static Color getSeparatorColor(BuildContext context) {
    return context.faColors.divider.subtle;
  }
}
