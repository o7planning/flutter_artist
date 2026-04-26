import 'package:flutter/material.dart';

import '_sorting_options.dart';
import '_style.dart';

/// Style configuration for the [PopupSortPanel].
class PopupSortPanelStyle extends SortPanelStyle {
  final IconData buttonIcon;
  final double buttonIconSize;
  final Color? buttonIconColor;
  final Decoration? menuDecoration;
  final PopupTextPosition textPosition;
  final double textIconSpacing;
  final SortIconBuilder? iconBuilder;
  final double height;

  const PopupSortPanelStyle({
    super.textStyle,
    super.iconSpacing,
    super.sortIconSize,
    super.draggingColor,
    super.boldActiveText,
    this.buttonIcon = Icons.sort,
    this.buttonIconSize = 16,
    this.buttonIconColor,
    this.menuDecoration,
    this.textPosition = PopupTextPosition.left,
    this.textIconSpacing = 8,
    this.iconBuilder,
    this.height = 36,
  });
}

enum PopupTextPosition { left, right, none }
