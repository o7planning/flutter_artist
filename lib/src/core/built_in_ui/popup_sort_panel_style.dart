import 'package:flutter/material.dart';

import '_tile.dart';

class PopupSortPanelStyle extends SortPanelStyle {
  final IconData buttonIcon;

  final double buttonIconSize;

  final Color? buttonIconColor;

  final EdgeInsetsGeometry menuPadding;

  final Decoration? menuDecoration;

  final TextStyle? menuTextStyle;

  final double itemSpacing;

  const PopupSortPanelStyle({
    super.textStyle,
    super.iconSpacing,
    super.sortIconSize,
    super.draggingColor,
    this.buttonIcon = Icons.sort,
    this.buttonIconSize = 18,
    this.buttonIconColor,
    this.menuPadding = const EdgeInsets.symmetric(vertical: 4),
    this.menuDecoration,
    this.menuTextStyle,
    this.itemSpacing = 8,
  });
}
