part of '../_fa_core.dart';

const double _sortIconSize = 16;

// ---------------------------------------------------------------------------

Widget _buildSortBtn({
  required ItemSortCriteria itemSortCriteria,
  required SortCriterion sortCriterion,
  required bool enabled,
  required bool isDragging,
  required bool acceptNoneDirection,
}) {
  return InkWell(
    onTap: enabled
        ? () {
            SortingDirection nextDirection = sortCriterion.getNextDirection(
              acceptNoneDirection: acceptNoneDirection,
            );
            SortCriterion updateCriterion = sortCriterion.copyWith(
              direction: nextDirection,
            );
            //
            itemSortCriteria.updateSortCriterion(
              updateCriterion: updateCriterion,
              moveToFirst: false,
            );
          }
        : null,
    child: _getSortIcon(sortCriterion, isDragging),
  );
}

// ---------------------------------------------------------------------------

Widget _getSortIcon(SortCriterion criterion, bool isDragging) {
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
