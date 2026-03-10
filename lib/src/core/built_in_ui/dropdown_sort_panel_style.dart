import 'package:flutter/material.dart';
import 'package:flutter_artist/src/core/built_in_ui/_tile.dart';

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
    this.dropdownIcon = Icons.keyboard_arrow_down,
    this.dropdownIconSize = 18,
    this.dropdownIconColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    this.decoration,
    this.isDense = true,
  });
}
