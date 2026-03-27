import 'package:flutter/material.dart';

import '_sorting_options.dart';
import '_tile.dart';

/// Style configuration for the [AdaptiveSortPanel].
class AdaptiveSortPanelStyle extends SortPanelStyle {
  final double height;
  final EdgeInsetsGeometry padding;
  final double itemSpacing;
  final double itemEstimatedWidth;
  final IconData moreIcon;
  final Color? moreIconColor;
  final Decoration? decoration;
  final SortIconBuilder? iconBuilder;

  const AdaptiveSortPanelStyle({
    super.textStyle,
    super.iconSpacing,
    super.sortIconSize,
    super.draggingColor,
    super.boldActiveText, // Custom bold option from base
    this.height = 36,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
    this.itemSpacing = 8,
    this.itemEstimatedWidth = 120.0,
    this.moreIcon = Icons.more_horiz,
    this.moreIconColor,
    this.decoration,
    this.iconBuilder,
  });
}
