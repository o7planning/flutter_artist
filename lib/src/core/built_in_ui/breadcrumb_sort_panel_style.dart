import 'package:flutter/material.dart';

import '_tile.dart';

class BreadcrumbSortPanelStyle extends SortPanelStyle {
  final double itemSpacing;
  final TextStyle? draggingTextStyle;
  final Color? dividerColor;
  final double dividerHeight;
  final double dividerThickness;
  final IconData dragFeedbackIcon;
  final Color? dragFeedbackColor;

  const BreadcrumbSortPanelStyle({
    super.textStyle,
    super.iconSpacing,
    super.sortIconSize,
    super.draggingColor,
    super.boldActiveText,
    this.itemSpacing = 5,
    this.draggingTextStyle,
    this.dividerColor,
    this.dividerHeight = 20,
    this.dividerThickness = 1.0,
    this.dragFeedbackIcon = Icons.unfold_more_rounded,
    this.dragFeedbackColor,
  });
}
