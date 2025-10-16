import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart';

import '../_core_/core.dart';
import '../enums/_sorting_direction.dart';

const double _sortIconSize = 16;

// ---------------------------------------------------------------------------

Widget buildSortBtn({
  required SortingModel sortingModel,
  required SortingCriterion sortingCriterion,
  required bool enabled,
  required bool isDragging,
  required bool acceptNoneDirection,
  required bool clearDirectionOfOtherCriteria,
}) {
  return InkWell(
    onTap: enabled
        ? () {
            SortingDirection nextDirection = sortingCriterion.getNextDirection(
              acceptNoneDirection: acceptNoneDirection,
            );
            sortingModel.updateSortingCriterionByName(
              criterionName: sortingCriterion.criterionName,
              direction: nextDirection,
              moveToFirst: false,
              clearDirectionOfOtherCriteria: clearDirectionOfOtherCriteria,
            );
          }
        : null,
    child: getSortIcon(sortingCriterion.direction, isDragging),
  );
}

// ---------------------------------------------------------------------------

Widget getSortIcon(SortingDirection direction, bool isDragging) {
  Color? color = isDragging ? Colors.grey : null;
  switch (direction) {
    case SortingDirection.ascending:
      return Icon(
        cupertino.CupertinoIcons.sort_up,
        size: _sortIconSize,
        color: color,
      );
    case SortingDirection.descending:
      return Icon(
        cupertino.CupertinoIcons.sort_down,
        size: _sortIconSize,
        color: color,
      );
    case SortingDirection.none:
      return Icon(
        cupertino.CupertinoIcons.line_horizontal_3,
        size: _sortIconSize,
        color: color,
      );
  }
}
