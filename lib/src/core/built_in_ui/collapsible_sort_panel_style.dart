import 'package:flutter/material.dart';

import '_style.dart';

class CollapsibleSortPanelStyle extends SortPanelStyle {
  final EdgeInsetsGeometry padding;
  final double buttonSpacing;
  final IconData sortIcon;
  final double iconSize;
  final Color? iconColor;
  final double height;

  const CollapsibleSortPanelStyle({
    super.textStyle,
    super.iconSpacing,
    super.sortIconSize,
    super.draggingColor,
    super.boldActiveText,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
    this.buttonSpacing = 6,
    this.sortIcon = Icons.sort,
    this.iconSize = 18,
    this.iconColor,
    this.height = 36,
  });
}
