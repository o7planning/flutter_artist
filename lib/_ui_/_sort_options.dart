part of '../flutter_artist.dart';

const double _sortIconSize = 16;

// ---------------------------------------------------------------------------

Widget _buildSortBtn({
  required Block block,
  required BlockItemComparator blockComparator,
  required _SortSignAndPropName signAndPropName,
  required bool isDragging,
}) {
  return InkWell(
    child: _getSortIcon(signAndPropName, isDragging),
    onTap: () {
      SortSign nextSign = signAndPropName.getNextSign();
      _SortSignAndPropName updateSapn = signAndPropName.copyWith(nextSign);
      blockComparator._updateSignAndPropName(updateSapn);
      block.data.sort();
      block.updateAllUIComponents(withoutFilters: true);
    },
  );
}

// ---------------------------------------------------------------------------

Widget _getSortIcon(_SortSignAndPropName sapn, bool isDragging) {
  Color? color = isDragging ? Colors.grey : null;
  if (sapn.isAscending()) {
    return Icon(
      cupertino.CupertinoIcons.sort_up,
      size: _sortIconSize,
      color: color,
    );
  } else if (sapn.isDescending()) {
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
