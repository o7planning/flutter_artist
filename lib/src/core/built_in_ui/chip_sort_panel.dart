import 'package:flutter/material.dart';

import '../_core_/core.dart';
import '_sorting_options.dart';
import 'chip_sort_panel_style.dart';

class ChipSortPanel<ITEM extends Object> extends SortPanel<ITEM> {
  final ChipSortPanelStyle style;
  final WrapAlignment alignment;

  const ChipSortPanel({
    super.key,
    required super.sortModel,
    this.style = const ChipSortPanelStyle(),
    this.alignment = WrapAlignment.start,
  });

  @override
  Widget buildContent(BuildContext context) {
    return Padding(
      padding: style.padding,
      child: Wrap(
        alignment: alignment,
        spacing: style.spacing,
        runSpacing: style.runSpacing,
        children: sortModel.criteria.map((criterion) {
          final selected = criterion.direction != null;

          return Chip(
            label: Text(
              criterion.text,
              style: selected && style.selectedTextStyle != null
                  ? style.selectedTextStyle
                  : style.textStyle,
            ),
            labelPadding: EdgeInsets.only(right: style.iconSpacing),
            deleteIcon: buildSortButton(
              context: context,
              sortModel: sortModel,
              criterion: criterion,
              enabled: true,
              isDragging: false,
              iconSize: style.sortIconSize,
              draggingColor: style.draggingColor,
            ),
            backgroundColor:
                selected ? style.selectedColor : style.backgroundColor,
            shape: style.chipShape ?? const StadiumBorder(),
          );
        }).toList(),
      ),
    );
  }
}
