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
    BlockItemComparator? blockComparator = block.itemComparator;
    //
    return BlockFragmentWidgetBuilder(
      ownerClassInstance: this,
      description: null,
      block: block,
      build: () {
        List<_SignAndPropName> sapnList =
            blockComparator?._signAndPropNames ?? [];
        _SignAndPropName? selected = sapnList.firstOrNull;
        //
        return DropdownButton<_SignAndPropName>(
          isDense: true,
          value: selected,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: sapnList.map(
            (sapn) {
              return DropdownMenuItem(
                value: sapn,
                child: _builSortCriterionView(
                  blockComparator: blockComparator!,
                  signAndPropName: sapn,
                ),
              );
            },
          ).toList(),
          onChanged: (_SignAndPropName? newValue) {
            // setState(() {
            //   dropdownvalue = newValue!;
            // });
          },
        );
      },
    );
  }

  Widget _builSortCriterionView({
    required BlockItemComparator blockComparator,
    required _SignAndPropName signAndPropName,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          signAndPropName.propName,
          style: textStyle,
        ),
        SizedBox(width: iconSpacing),
        _buildSortBtn(
          block: block,
          blockComparator: blockComparator,
          signAndPropName: signAndPropName,
          isDragging: false,
        ),
      ],
    );
  }
}
