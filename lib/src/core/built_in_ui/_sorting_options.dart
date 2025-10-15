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
}) {
  return InkWell(
    onTap: enabled
        ? () {
            SortingDirection nextDirection = sortingCriterion.getNextDirection(
              acceptNoneDirection: acceptNoneDirection,
            );
            SortingCriterion updateCriterion = sortingCriterion.copyWith(
              direction: nextDirection,
            );
            //
            sortingModel.updateSortingCriterion(
              updateCriterion: updateCriterion,
              moveToFirst: false,
            );
          }
        : null,
    child: getSortIcon(sortingCriterion, isDragging),
  );
}

// ---------------------------------------------------------------------------

Widget getSortIcon(SortingCriterion criterion, bool isDragging) {
  Color? color = isDragging ? Colors.grey : null;
  if (criterion.isAscending()) {
    return Icon(
      cupertino.CupertinoIcons.sort_up,
      size: _sortIconSize,
      color: color,
    );
  } else if (criterion.isDescending()) {
    return Icon(
      cupertino.CupertinoIcons.sort_down,
      size: _sortIconSize,
      color: color,
    );
  } else {
    return Icon(
      cupertino.CupertinoIcons.line_horizontal_3,
      size: _sortIconSize,
      color: color,
    );
  }
}
