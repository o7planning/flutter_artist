import 'package:flutter/material.dart';

import '_style.dart';

/// Style configuration for the [DialogSortPanel].
class DialogSortPanelStyle extends SortPanelStyle {
  final String title;
  final String applyButtonText;
  final String cancelButtonText;
  final IconData triggerIcon;
  final double triggerIconSize;
  final Color? triggerIconColor;
  final double height;
  final double dialogMaxWidth;

  /// The scale factor for the Switch widget to make it "tiny and cute".
  /// Default is 0.8 (20% smaller).
  final double switchScale;

  const DialogSortPanelStyle({
    super.textStyle,
    super.iconSpacing,
    super.sortIconSize,
    super.draggingColor,
    super.boldActiveText,
    this.switchScale = 0.8,
    this.title = 'Sort Options',
    this.applyButtonText = 'Apply',
    this.cancelButtonText = 'Cancel',
    this.triggerIcon =
        Icons.tune_rounded, // Tune icon looks more "Pro" for dialogs
    this.triggerIconSize = 18,
    this.triggerIconColor,
    this.height = 36,
    this.dialogMaxWidth = 400,
  });
}
