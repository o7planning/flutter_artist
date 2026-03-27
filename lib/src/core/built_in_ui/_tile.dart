import 'package:flutter/material.dart';

import '../_core_/core.dart';

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
    final theme = Theme.of(context);
    final baseStyle = textStyle.copyWith(
      color: isActive
          ? theme.primaryColor
          : theme.colorScheme.onSurface.withValues(alpha: 0.8),
    );
    if (!isActive) return baseStyle;
    return baseStyle.copyWith(
      fontWeight: boldActiveText ? FontWeight.bold : baseStyle.fontWeight,
    );
  }
}

/// A mixin to provide shared sorting logic across different panel types.
mixin SortPanelMixin {
  /// Standardized method to toggle a criterion's direction.
  void toggleCriterionByName(SortModel sortModel, SortCriterion criterion) {
    sortModel.updateSortingCriterionByName(
      criterionName: criterion.criterionName,
      direction: criterion.nextDirection,
      moveToFirst: false,
    );
  }
}
