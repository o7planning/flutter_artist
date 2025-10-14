part of '../core.dart';

class SortOptionsDropdown extends StatelessWidget {
  final Block _block;
  final TextStyle textStyle;
  final double iconSpacing;

  const SortOptionsDropdown({
    super.key,
    required Block block,
    this.iconSpacing = 3,
    this.textStyle = const TextStyle(fontSize: 14),
  }) : _block = block;

  const SortOptionsDropdown.simple({
    super.key,
    required Block block,
    this.iconSpacing = 3,
    this.textStyle = const TextStyle(fontSize: 14),
  }) : _block = block;

  @override
  Widget build(BuildContext context) {
    return BlockFragmentViewBuilder(
      ownerClassInstance: this,
      description: null,
      block: _block,
      build: () {
        SortingModel? sortingModel = _block.sortingModel;
        //
        List<SortingCriterion> criteria = sortingModel?.criteria ?? [];
        SortingCriterion? selectedSortingCriterion =
            sortingModel?.selectedCriterion ??
                sortingModel?.getFirstSortingCriterion();
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
                  sortingModel: sortingModel!,
                  sortingCriterion: criterion,
                  selectedSortingCriterion: selectedSortingCriterion,
                ),
              );
            },
          ).toList(),
          onChanged: _onChanged,
        );
      },
    );
  }

  void _onChanged(SortingCriterion? newValue) {
    if (newValue == null) {
      return;
    }
    SortingModel? sortingModel = _block.sortingModel;
    if (sortingModel == null) {
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
        _buildSortBtn(
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
