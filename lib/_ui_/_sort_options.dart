part of '../flutter_artist.dart';

const double _sortIconSize = 16;

// ---------------------------------------------------------------------------

Widget _buildSortBtn({
  required ItemSortCriteria itemSortCriteria,
  required SortCriterion sortCriterion,
  required bool isDragging,
}) {
  return InkWell(
    child: _getSortIcon(sortCriterion, isDragging),
    onTap: () {
      SortingDirection nextSign = sortCriterion.getNextDirection();
      itemSortCriteria.updateSortCriterion(
        propName: sortCriterion.propName,
        direction: nextSign,
      );
    },
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
