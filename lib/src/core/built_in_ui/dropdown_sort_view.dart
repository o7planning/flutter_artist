import 'package:flutter/material.dart';

import '../_core_/core.dart';
import '../enums/_sorting_direction.dart';
import '_sorting_options.dart';

class DropdownSortView<ITEM extends Object> extends SortView<ITEM> {
  final TextStyle textStyle;
  final double iconSpacing;

  const DropdownSortView({
    super.key,
    required super.sortingModel,
    this.iconSpacing = 3,
    this.textStyle = const TextStyle(fontSize: 14),
  });

  const DropdownSortView.simple({
    super.key,
    required super.sortingModel,
    this.iconSpacing = 3,
    this.textStyle = const TextStyle(fontSize: 14),
  });

  @override
  Widget buildContent(BuildContext context) {
    List<SortingCriterion> criteria = sortingModel.criteria;
    SortingCriterion? selectedSortingCriterion =
        sortingModel.selectedCriterion ??
            sortingModel.getFirstSortingCriterion();
    //
    return DropdownButton<SortingCriterion>(
      isDense: true,
      value: selectedSortingCriterion,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: criteria.map(
        (criterion) {
          return DropdownMenuItem(
            value: criterion,
            child: _buildSortingCriterionView(
              sortingModel: sortingModel,
              sortingCriterion: criterion,
              selectedSortingCriterion: selectedSortingCriterion,
            ),
          );
        },
      ).toList(),
      onChanged: _onChanged,
    );
  }

  void _onChanged(SortingCriterion? newValue) {
    if (newValue == null) {
      return;
    }
    SortingDirection direction = newValue.direction;
    if (direction == SortingDirection.none) {
      direction = SortingDirection.ascending;
    }
    sortingModel.setSelectedCriterion(newValue);
    sortingModel.updateSortingCriterionByName(
      criterionName: newValue.criterionName,
      direction: direction,
      moveToFirst: false,
      clearDirectionOfOtherCriteria: false,
    );
  }

  Widget _buildSortingCriterionView({
    required SortingModel sortingModel,
    required SortingCriterion sortingCriterion,
    required SortingCriterion? selectedSortingCriterion,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          sortingCriterion.text,
          style: textStyle,
        ),
        SizedBox(width: iconSpacing),
        buildSortBtn(
          sortingModel: sortingModel,
          sortingCriterion: sortingCriterion,
          isDragging: false,
          acceptNoneDirection: false,
          clearDirectionOfOtherCriteria: false,
          enabled: sortingCriterion.criterionName ==
              selectedSortingCriterion?.criterionName,
        ),
      ],
    );
  }
}
