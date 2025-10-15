import 'package:flutter/material.dart';

import '../_core_/core.dart';
import '../enums/_sorting_direction.dart';
import '_sorting_options.dart';

class SortingOptionDropdown<ITEM extends Object> extends SortView<ITEM> {
  final TextStyle textStyle;
  final double iconSpacing;

  const SortingOptionDropdown({
    super.key,
    required super.sortingModel,
    required super.sortingSide,
    this.iconSpacing = 3,
    this.textStyle = const TextStyle(fontSize: 14),
  });

  const SortingOptionDropdown.simple({
    super.key,
    required super.sortingModel,
    required super.sortingSide,
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
    if (newValue.isNonDirection()) {
      newValue = newValue.copyWith(
        direction: SortingDirection.ascending,
      );
    }
    List<SortingCriterion> updateCriteria =
        sortingModel.getCopyOfSortingCriteria(
      clearAllDirections: true,
      appliedCriterion: newValue,
    );
    //
    sortingModel.setSelectedCriterion(newValue);
    sortingModel.updateSortingCriteria(
      updateCriteria: updateCriteria,
      rearrangeCriteria: false,
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
          enabled: sortingCriterion.criterionName ==
              selectedSortingCriterion?.criterionName,
        ),
      ],
    );
  }
}
