import 'package:flutter/material.dart';

import '../_core_/core.dart';
import 'toolbar_sort_panel_style.dart';

class ToolbarSortPanel<ITEM extends Object> extends SortPanel<ITEM> {
  final ToolbarSortPanelStyle style;

  const ToolbarSortPanel({
    super.key,
    required super.sortModel,
    this.style = const ToolbarSortPanelStyle(),
  });

  @override
  Widget buildContent(BuildContext context) {
    final selected = sortModel.findFirstCriterionHasDirection() ??
        (sortModel.criteria.isNotEmpty ? sortModel.criteria.first : null);

    if (selected == null) return const SizedBox();

    return Padding(
      padding: style.padding,
      child: Row(
        children: [
          TextButton.icon(
            onPressed: () {
              sortModel.updateSortingCriterionByName(
                criterionName: selected.criterionName,
                direction: selected.nextDirection,
                moveToFirst: false,
              );
            },
            icon: Icon(
              style.sortIcon,
              size: style.iconSize,
              color: style.iconColor,
            ),
            label: Text(
              selected.text,
              style: style.labelTextStyle ?? style.textStyle,
            ),
          )
        ],
      ),
    );
  }
}
