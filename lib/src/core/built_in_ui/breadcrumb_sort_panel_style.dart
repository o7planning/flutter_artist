import 'package:flutter/material.dart';

class BreadcrumbSortPanelStyle {
  final double itemSpacing;
  final double iconSpacing;
  final TextStyle textStyle;
  final TextStyle? draggingTextStyle;
  final Color dividerColor;
  final double dividerHeight;
  final double dividerThickness;
  final IconData dragFeedbackIcon;
  final Color dragFeedbackColor;

  const BreadcrumbSortPanelStyle({
    this.itemSpacing = 5,
    this.iconSpacing = 3,
    this.textStyle = const TextStyle(fontSize: 14),
    this.draggingTextStyle,
    this.dividerColor = const Color(0x503F51B5), // Indigo with alpha
    this.dividerHeight = 20,
    this.dividerThickness = 1.0,
    this.dragFeedbackIcon = Icons.unfold_more_rounded,
    this.dragFeedbackColor = Colors.indigo,
  });
}
