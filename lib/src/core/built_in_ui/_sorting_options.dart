import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart';

import '../_core_/core.dart';
import '../enums/_sort_direction.dart';
import '_sort_panel_helper.dart';

typedef SortCriterionItemBuilder = Widget Function(
  BuildContext context,
  SortCriterion criterion,
  bool isSelected,
  VoidCallback toggleDirection,
);

typedef SortIconBuilder = Widget Function(
  BuildContext context,
  SortDirection? direction,
  bool isDragging,
  double size,
  Color? draggingColor,
);

/// A mixin to provide shared sorting logic across different panel types.
mixin SortPanelMixin {
  /// Standardized method to toggle a criterion's direction.
  void toggleCriterionByName(SortModel sortModel, SortCriterion criterion) {
    sortModel.updateSortingCriterionByName(
      criterionName: criterion.criterionName,
      direction: criterion.nextDirection,
      moveToFirst: false,
    );
  }
}

Widget defaultSortIcon(
  BuildContext context,
  SortDirection? direction,
  bool isDragging,
  double size,
  Color? draggingColor,
) {
  final isActive = direction != null;
  final color = isDragging
      ? draggingColor
      : SortPanelHelper.getSortIconColor(context, isActive);

  switch (direction) {
    case SortDirection.asc:
      return Icon(cupertino.CupertinoIcons.sort_up, size: size, color: color);
    case SortDirection.desc:
      return Icon(cupertino.CupertinoIcons.sort_down, size: size, color: color);
    case null:
      return Icon(cupertino.CupertinoIcons.line_horizontal_3,
          size: size, color: color);
  }
}

void toggleCriterion(
  SortModel sortModel,
  SortCriterion criterion,
) {
  sortModel.updateSortingCriterionByName(
    criterionName: criterion.criterionName,
    direction: criterion.nextDirection,
    moveToFirst: false,
  );
}

Widget buildSortButton({
  required BuildContext context,
  required SortModel sortModel,
  required SortCriterion criterion,
  required bool enabled,
  required bool isDragging,
  required double iconSize,
  required Color? draggingColor,
  SortIconBuilder? iconBuilder,
  VoidCallback? onToggle,
}) {
  final VoidCallback handleToggle =
      onToggle ?? () => toggleCriterion(sortModel, criterion);

  return InkWell(
    onTap: enabled ? handleToggle : null,
    child: (iconBuilder ?? defaultSortIcon)(
      context,
      criterion.direction,
      isDragging,
      iconSize,
      null,
    ),
  );
}
