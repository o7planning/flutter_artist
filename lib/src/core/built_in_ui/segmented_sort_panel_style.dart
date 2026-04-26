import 'package:flutter/material.dart';

import '_style.dart';

class SegmentedSortPanelStyle extends SortPanelStyle {
  final EdgeInsetsGeometry padding;
  final Decoration? decoration;
  final BorderRadius? borderRadius;
  final Color? selectedColor;
  final Color? unselectedColor;
  final VisualDensity visualDensity;
  final MaterialTapTargetSize tapTargetSize;

  const SegmentedSortPanelStyle({
    super.textStyle,
    super.iconSpacing,
    super.sortIconSize,
    super.draggingColor,
    super.boldActiveText,
    this.padding = const EdgeInsets.all(4),
    this.decoration,
    this.borderRadius,
    this.selectedColor,
    this.unselectedColor,
    this.visualDensity = VisualDensity.compact,
    this.tapTargetSize = MaterialTapTargetSize.shrinkWrap,
  });
}
