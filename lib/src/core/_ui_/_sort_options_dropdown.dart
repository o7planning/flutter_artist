part of '../_fa_core.dart';

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
        ItemSortCriteria? itemSortCriteria = _block.itemSortCriteria;
        //
        List<SortCriterion> criteria = itemSortCriteria?.criteria ?? [];
        SortCriterion? selectedSortCriterion =
            itemSortCriteria?.selectedCriterion ??
                itemSortCriteria?.getFirstSortCriterion();
        //
        return DropdownButton<SortCriterion>(
          isDense: true,
          value: selectedSortCriterion,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: criteria.map(
            (criterion) {
              return DropdownMenuItem(
                value: criterion,
                child: _buildSortCriterionView(
                  itemSortCriteria: itemSortCriteria!,
                  sortCriterion: criterion,
                  selectedSortCriterion: selectedSortCriterion,
                ),
              );
            },
          ).toList(),
          onChanged: _onChanged,
        );
      },
    );
  }

  void _onChanged(SortCriterion? newValue) {
    if (newValue == null) {
      return;
    }
    ItemSortCriteria? itemSortCriteria = _block.itemSortCriteria;
    if (itemSortCriteria == null) {
      return;
    }
    if (newValue.isNonDirection()) {
      newValue = newValue.copyWith(
        direction: SortingDirection.ascending,
      );
    }
    List<SortCriterion> updateCriteria = itemSortCriteria.getCopyOfSortCriteria(
      clearAllDirections: true,
      appliedCriterion: newValue,
    );
    //
    itemSortCriteria.setSelectedCriterion(newValue);
    itemSortCriteria.updateSortCriteria(
      updateCriteria: updateCriteria,
      rearrangeCriteria: false,
    );
  }

  Widget _buildSortCriterionView({
    required ItemSortCriteria itemSortCriteria,
    required SortCriterion sortCriterion,
    required SortCriterion? selectedSortCriterion,
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
        _buildSortBtn(
          itemSortCriteria: itemSortCriteria,
          sortCriterion: sortCriterion,
          isDragging: false,
          acceptNoneDirection: false,
          enabled: sortCriterion.propName == selectedSortCriterion?.propName,
        ),
      ],
    );
  }
}
