import 'package:flutter/material.dart';

import '../_core_/core.dart';
import '../enums/_sort_direction.dart';
import '_sorting_options.dart';

// TODO: Garbage collection.
final __privateGlobalMap = <SortModel, SortCriterion?>{};

class DropdownSortPanel<ITEM extends Object> extends SortPanel<ITEM> {
  final TextStyle textStyle;
  final double iconSpacing;

  const DropdownSortPanel({
    super.key,
    required super.sortModel,
    this.iconSpacing = 3,
    this.textStyle = const TextStyle(fontSize: 14),
  });

  const DropdownSortPanel.simple({
    super.key,
    required super.sortModel,
    this.iconSpacing = 3,
    this.textStyle = const TextStyle(fontSize: 14),
  });

  @override
  Widget buildContent(BuildContext context) {
    List<SortCriterion> criteria = sortModel.criteria;
    SortCriterion? selected = __privateGlobalMap[sortModel];
    if (selected == null) {
      selected = sortModel.findFirstCriterionHasDirection() ??
          sortModel.criteria.firstOrNull;
      __privateGlobalMap[sortModel] = selected;
    }

    //
    return DropdownButton<SortCriterion>(
      isDense: true,
      value: selected,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: criteria.map(
        (criterion) {
          return DropdownMenuItem(
            value: criterion,
            child: _buildSortingCriterionView(
              sortModel: sortModel,
              sortCriterion: criterion,
              selectedSortingCriterion: selected,
            ),
          );
        },
      ).toList(),
      onChanged: _onChanged,
    );
  }

  void _onChanged(SortCriterion? selectedSortCriterion) {
    if (selectedSortCriterion == null) {
      return;
    }
    __privateGlobalMap[sortModel] = selectedSortCriterion;

    SortDirection? direction = selectedSortCriterion.direction;
    direction ??= selectedSortCriterion.lastUsedDirection ??
        selectedSortCriterion.initialDirection ??
        SortDirection.asc;

    sortModel.updateSortingCriterionByName(
      criterionName: selectedSortCriterion.criterionName,
      direction: direction,
      moveToFirst: false,
    );
  }

  Widget _buildSortingCriterionView({
    required SortModel sortModel,
    required SortCriterion sortCriterion,
    required SortCriterion? selectedSortingCriterion,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          sortCriterion.text,
          style: textStyle,
        ),
        SizedBox(width: iconSpacing),
        buildSortBtn(
          sortModel: sortModel,
          sortCriterion: sortCriterion,
          isDragging: false,
          acceptNonDirection: sortCriterion.acceptNonDirection,
          enabled: sortCriterion.criterionName ==
              selectedSortingCriterion?.criterionName,
        ),
      ],
    );
  }
}
