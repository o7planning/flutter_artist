import 'package:flutter/material.dart';

import '../_core_/core.dart';
import '../enums/_sort_direction.dart';
import '_sorting_options.dart';

class DropdownSortView<ITEM extends Object> extends SortView<ITEM> {
  final TextStyle textStyle;
  final double iconSpacing;

  const DropdownSortView({
    super.key,
    required super.sortModel,
    this.iconSpacing = 3,
    this.textStyle = const TextStyle(fontSize: 14),
  });

  const DropdownSortView.simple({
    super.key,
    required super.sortModel,
    this.iconSpacing = 3,
    this.textStyle = const TextStyle(fontSize: 14),
  });

  @override
  Widget buildContent(BuildContext context) {
    List<SortCriterion> criteria = sortModel.criteria;
    SortCriterion? selectedSortingCriterion =
        sortModel.selectedCriterion ?? sortModel.getFirstSortingCriterion();
    //
    return DropdownButton<SortCriterion>(
      isDense: true,
      value: selectedSortingCriterion,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: criteria.map(
        (criterion) {
          return DropdownMenuItem(
            value: criterion,
            child: _buildSortingCriterionView(
              sortModel: sortModel,
              sortCriterion: criterion,
              selectedSortingCriterion: selectedSortingCriterion,
            ),
          );
        },
      ).toList(),
      onChanged: _onChanged,
    );
  }

  void _onChanged(SortCriterion? newValue) {
    if (newValue == null) {
      return;
    }
    SortDirection? direction = newValue.direction;
    direction ??= SortDirection.ascending;

    sortModel.setSelectedCriterion(newValue);
    sortModel.updateSortingCriterionByName(
      criterionName: newValue.criterionName,
      direction: direction,
      moveToFirst: false,
      clearDirectionOfOtherCriteria: false,
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
          acceptNoneDirection: false,
          clearDirectionOfOtherCriteria: false,
          enabled: sortCriterion.criterionName ==
              selectedSortingCriterion?.criterionName,
        ),
      ],
    );
  }
}
