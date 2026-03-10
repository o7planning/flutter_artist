import 'package:flutter/material.dart';
import 'package:flutter_artist/src/core/built_in_ui/_tile.dart';

import '../_core_/core.dart';
import '../enums/_sort_direction.dart';
import '_sorting_options.dart';
import 'dropdown_sort_panel_style.dart';

class DropdownSortPanel<ITEM extends Object> extends SortPanel<ITEM> {
  final DropdownSortPanelStyle style;

  final SortCriterionItemBuilder? itemBuilder;

  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;
  final EdgeInsetsGeometry? margin;

  const DropdownSortPanel({
    super.key,
    required super.sortModel,
    this.style = const DropdownSortPanelStyle(),
    this.itemBuilder,
    this.alignment,
    this.padding,
    this.decoration,
    this.margin,
  });

  @override
  Widget buildContent(BuildContext context) {
    SortCriterion? selected = sortModel.findFirstCriterionHasDirection() ??
        (sortModel.criteria.isNotEmpty ? sortModel.criteria.first : null);

    return Container(
      alignment: alignment,
      padding: padding ?? style.padding,
      decoration: decoration ?? style.decoration,
      margin: margin,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SortCriterion>(
          isDense: style.isDense,
          value: selected,
          icon: Icon(
            style.dropdownIcon,
            size: style.dropdownIconSize,
            color: style.dropdownIconColor,
          ),
          items: sortModel.criteria
              .map(
                (criterion) => DropdownMenuItem(
                  value: criterion,
                  child: _buildItem(
                    context,
                    criterion,
                    selected,
                  ),
                ),
              )
              .toList(),
          onChanged: (value) => _onChanged(value),
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    SortCriterion criterion,
    SortCriterion? selected,
  ) {
    final toggle = () => _toggleCriterion(criterion);

    if (itemBuilder != null) {
      return itemBuilder!(
        context,
        criterion,
        criterion == selected,
        toggle,
      );
    }

    return SortCriterionTile(
      sortModel: sortModel,
      criterion: criterion,
      style: style,
      enabled: criterion == selected,
    );
  }

  void _toggleCriterion(SortCriterion criterion) {
    sortModel.updateSortingCriterionByName(
      criterionName: criterion.criterionName,
      direction: criterion.nextDirection,
      moveToFirst: false,
    );
  }

  void _onChanged(SortCriterion? selected) {
    if (selected == null) return;

    SortDirection? direction = selected.direction ??
        selected.lastUsedDirection ??
        selected.initialDirection ??
        SortDirection.asc;

    sortModel.updateSortingCriterionByName(
      criterionName: selected.criterionName,
      direction: direction,
      moveToFirst: false,
    );
  }
}
