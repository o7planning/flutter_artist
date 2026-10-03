import 'package:flutter/material.dart';

import '_sort_panel_helper.dart';

/// Base configuration style for all Sort Panels.
abstract class SortPanelStyle {
  final TextStyle textStyle;
  final double iconSpacing;
  final double sortIconSize;
  final Color? draggingColor;

  /// Determines if the text should be bold when the criterion is active.
  final bool boldActiveText;

  const SortPanelStyle({
    this.textStyle = const TextStyle(fontSize: 14),
    this.iconSpacing = 4,
    this.sortIconSize = 16,
    this.draggingColor,
    this.boldActiveText = false,
  });

  /// Returns the appropriate text style based on the active state.
  TextStyle getTextStyle(BuildContext context, bool isActive) {
    final Color effectiveColor =
        SortPanelHelper.getTextColor(context, isActive);

    final baseStyle = textStyle.copyWith(
      color: effectiveColor,
    );

    if (!isActive) return baseStyle;

    return baseStyle.copyWith(
      fontWeight: boldActiveText ? FontWeight.bold : baseStyle.fontWeight,
    );
  }
}
