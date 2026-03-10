import 'package:flutter/material.dart';

import '_tile.dart';

class ChipSortPanelStyle extends SortPanelStyle {
  final EdgeInsetsGeometry padding;

  final double spacing;
  final double runSpacing;

  final OutlinedBorder? chipShape;

  final Color? selectedColor;
  final Color? backgroundColor;

  final TextStyle? selectedTextStyle;

  const ChipSortPanelStyle({
    super.textStyle,
    super.iconSpacing,
    super.sortIconSize,
    super.draggingColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 4),
    this.spacing = 6,
    this.runSpacing = 6,
    this.chipShape,
    this.selectedColor,
    this.backgroundColor,
    this.selectedTextStyle,
  });
}
