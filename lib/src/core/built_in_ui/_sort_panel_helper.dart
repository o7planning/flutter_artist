import 'package:flutter/material.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

class SortPanelHelper {
  static Color getBackgroundColor(BuildContext context) {
    return FaColorUtils.surfaceContainerLow(context);
  }

  static BorderSide getBorder(BuildContext context) {
    return BorderSide(
      color: FaColorUtils.dividerColor(context).withValues(alpha: 0.5),
      width: 1,
    );
  }

  static Color getTextColor(BuildContext context, bool isActive) {
    if (isActive) return FaColorUtils.primaryAction(context);

    return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8);
  }

  static Color getSortIconColor(BuildContext context, bool isActive) {
    if (isActive) return FaColorUtils.primaryAction(context);
    return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);
  }

  static Color getSeparatorColor(BuildContext context) {
    return FaColorUtils.dividerColor(context).withValues(alpha: 0.4);
  }

  static Color getIconColor(BuildContext context, bool isActive) {
    if (isActive) return FaColorUtils.primaryAction(context);
    return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);
  }
}
