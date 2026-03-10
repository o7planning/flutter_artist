import 'package:flutter/material.dart';

import '_tile.dart';

class ToolbarSortPanelStyle extends SortPanelStyle {
  final EdgeInsetsGeometry padding;
  final double buttonSpacing;
  final IconData sortIcon;
  final double iconSize;
  final Color? iconColor;
  final TextStyle? labelTextStyle;

  const ToolbarSortPanelStyle({
    super.textStyle,
    super.iconSpacing,
    super.sortIconSize,
    super.draggingColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
    this.buttonSpacing = 6,
    this.sortIcon = Icons.sort,
    this.iconSize = 18,
    this.iconColor,
    this.labelTextStyle,
  });
}
