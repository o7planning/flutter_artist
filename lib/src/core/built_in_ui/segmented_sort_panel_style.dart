import 'package:flutter/material.dart';

import '_tile.dart';

class SegmentedSortPanelStyle extends SortPanelStyle {
  final EdgeInsetsGeometry padding;
  final Decoration? decoration;
  final double segmentSpacing;
  final BorderRadius? borderRadius;
  final Color? selectedColor;
  final Color? unselectedColor;

  final TextStyle? selectedTextStyle;

  const SegmentedSortPanelStyle({
    super.textStyle,
    super.iconSpacing,
    super.sortIconSize,
    super.draggingColor,
    this.padding = const EdgeInsets.all(4),
    this.decoration,
    this.segmentSpacing = 0,
    this.borderRadius,
    this.selectedColor,
    this.unselectedColor,
    this.selectedTextStyle,
  });
}
