part of '../flutter_artist.dart';

const double _sortIconSize = 16;

// ---------------------------------------------------------------------------

Widget _buildSortBtn({
  required Block block,
  required BlockItemComparator blockComparator,
  required _SignAndPropName signAndPropName,
  required bool isDragging,
}) {
  return InkWell(
    child: _getSortIcon(signAndPropName, isDragging),
    onTap: () {
      SortSign nextSign = signAndPropName.getNextSign();
      _SignAndPropName updateSapn = signAndPropName.copyWith(nextSign);
      blockComparator._updateSignAndPropName(updateSapn);
      block.data.sort();
      block.updateAllUIComponents(withoutFilters: true);
    },
  );
}

// ---------------------------------------------------------------------------

Widget _getSortIcon(_SignAndPropName sapn, bool isDragging) {
  Color? color = isDragging ? Colors.grey : null;
  if (sapn.isAsc()) {
    return Icon(
      cupertino.CupertinoIcons.sort_up,
      size: _sortIconSize,
      color: color,
    );
  } else if (sapn.isDesc()) {
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
