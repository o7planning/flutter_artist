import 'package:flutter/material.dart';

import '../_core_/core.dart';
import '_sorting_options.dart';
import 'segmented_sort_panel_style.dart';

class SegmentedSortPanel<ITEM extends Object> extends SortPanel<ITEM> {
  final SegmentedSortPanelStyle style;

  const SegmentedSortPanel({
    super.key,
    required super.sortModel,
    this.style = const SegmentedSortPanelStyle(),
  });

  @override
  Widget buildContent(BuildContext context) {
    final selected = sortModel.findFirstCriterionHasDirection();

    return Padding(
      padding: style.padding,
      child: SegmentedButton<SortCriterion>(
        emptySelectionAllowed: true,
        segments: sortModel.criteria.map((criterion) {
          return ButtonSegment(
            value: criterion,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  criterion.text,
                  style:
                      criterion == selected && style.selectedTextStyle != null
                          ? style.selectedTextStyle
                          : style.textStyle,
                ),
                SizedBox(width: style.iconSpacing),
                buildSortButton(
                  context: context,
                  sortModel: sortModel,
                  criterion: criterion,
                  enabled: true,
                  isDragging: false,
                  iconSize: style.sortIconSize,
                  draggingColor: style.draggingColor,
                ),
              ],
            ),
          );
        }).toList(),
        selected: selected == null ? {} : {selected},
        onSelectionChanged: (value) {
          final criterion = value.first;
          sortModel.updateSortingCriterionByName(
            criterionName: criterion.criterionName,
            direction: criterion.nextDirection,
            moveToFirst: false,
          );
        },
      ),
    );
  }
}
