part of '../flutter_artist.dart';

class SortOptionsDropdown extends StatelessWidget {
  final Block block;
  final TextStyle textStyle;
  final double iconSpacing;

  const SortOptionsDropdown({
    super.key,
    required this.block,
    this.iconSpacing = 3,
    this.textStyle = const TextStyle(fontSize: 14),
  });

  const SortOptionsDropdown.simple({
    super.key,
    required this.block,
    this.iconSpacing = 3,
    this.textStyle = const TextStyle(fontSize: 14),
  });

  @override
  Widget build(BuildContext context) {
    ItemSortCriteria? itemSortCriteria = block.itemSortCriteria;
    //
    return BlockFragmentWidgetBuilder(
      ownerClassInstance: this,
      description: null,
      block: block,
      build: () {
        List<SortCriterion> criteria = itemSortCriteria?._sortCriteria ?? [];
        SortCriterion? selected = criteria.firstOrNull;
        //
        return DropdownButton<SortCriterion>(
          isDense: true,
          value: selected,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: criteria.map(
            (criterion) {
              return DropdownMenuItem(
                value: criterion,
                child: _builSortCriterionView(
                  itemSortCriteria: itemSortCriteria!,
                  sortCriterion: criterion,
                ),
              );
            },
          ).toList(),
          onChanged: (SortCriterion? newValue) {
            // setState(() {
            //   dropdownvalue = newValue!;
            // });
          },
        );
      },
    );
  }

  Widget _builSortCriterionView({
    required ItemSortCriteria itemSortCriteria,
    required SortCriterion sortCriterion,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          sortCriterion.propName,
          style: textStyle,
        ),
        SizedBox(width: iconSpacing),
        _buildSortBtn(
          itemSortCriteria: itemSortCriteria,
          sortCriterion: sortCriterion,
          isDragging: false,
        ),
      ],
    );
  }
}
