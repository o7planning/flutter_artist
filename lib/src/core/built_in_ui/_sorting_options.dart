import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart';

import '../_core_/core.dart';
import '../enums/_sort_direction.dart';

const double _sortIconSize = 16;

// ---------------------------------------------------------------------------

Widget buildSortBtn({
  required SortModel sortModel,
  required SortCriterion sortCriterion,
  required bool enabled,
  required bool isDragging,
}) {
  return InkWell(
    onTap: enabled
        ? () {
            SortDirection? nextDirection = sortCriterion.getNextDirection();
            sortModel.updateSortingCriterionByName(
              criterionNameTilde: sortCriterion.criterionNameTilde,
              direction: nextDirection,
              moveToFirst: false,
            );
          }
        : null,
    child: getSortIcon(sortCriterion.direction, isDragging),
  );
}

// ---------------------------------------------------------------------------

Widget getSortIcon(SortDirection? direction, bool isDragging) {
  Color? color = isDragging ? Colors.grey : null;
  switch (direction) {
    case SortDirection.asc:
      return Icon(
        cupertino.CupertinoIcons.sort_up,
        size: _sortIconSize,
        color: color,
      );
    case SortDirection.desc:
      return Icon(
        cupertino.CupertinoIcons.sort_down,
        size: _sortIconSize,
        color: color,
      );
    case null:
      return Icon(
        cupertino.CupertinoIcons.line_horizontal_3,
        size: _sortIconSize,
        color: color,
      );
  }
}
