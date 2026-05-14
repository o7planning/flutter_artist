import 'package:flutter/material.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';

import '../_core_/core.dart';
import '_sort_panel_helper.dart';
import '_sorting_options.dart';
import 'chip_sort_panel_style.dart';

class ChipSortPanel<ITEM extends Object> extends SortPanel<ITEM>
    with SortPanelMixin {
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
    final tokens = context.faTokens;
    final theme = Theme.of(context);

    return Padding(
      padding: style.padding,
      child: Wrap(
        alignment: alignment,
        spacing: style.spacing,
        runSpacing: style.runSpacing,
        children: sortModel.criteria.map((criterion) {
          final isSelected = criterion.direction != null;

          final effectiveUnselectedColor = style.backgroundColor ??
              SortPanelHelper.getBackgroundColor(context);

          final effectiveSelectedColor = style.selectedColor ??
              SortPanelHelper.getTextColor(context, true)
                  .withValues(alpha: 0.15);

          return RawChip(
            label: Text(
              criterion.text,
              style: style.getTextStyle(context, isSelected),
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
            onDeleted: () => toggleCriterionByName(sortModel, criterion),
            onPressed: () => toggleCriterionByName(sortModel, criterion),
            backgroundColor: effectiveUnselectedColor,
            selectedColor: effectiveSelectedColor,
            shape: style.chipShape ??
                StadiumBorder(
                  side: SortPanelHelper.getBorder(context),
                ),
            selected: isSelected,
            showCheckmark: false,
          );
        }).toList(),
      ),
    );
  }
}
