import 'package:flutter/material.dart';

import '_tile.dart';

/// Style configuration for the [DropdownSortPanel].
class DropdownSortPanelStyle extends SortPanelStyle {
  final IconData dropdownIcon;
  final double dropdownIconSize;
  final Color? dropdownIconColor;
  final EdgeInsetsGeometry padding;
  final Decoration? decoration;
  final bool isDense;

  const DropdownSortPanelStyle({
    super.textStyle,
    super.iconSpacing,
    super.sortIconSize,
    super.draggingColor,
    super.boldActiveText,
    this.dropdownIcon = Icons.keyboard_arrow_down,
    this.dropdownIconSize = 18,
    this.dropdownIconColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    this.decoration,
    this.isDense = true,
  });
}
