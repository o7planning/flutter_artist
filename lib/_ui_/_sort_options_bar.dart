part of '../flutter_artist.dart';

class SortOptionsBar extends StatelessWidget {
  final Block block;
  final double itemSpacing;
  final double iconSpacing;

  final Color _dividerColor = Colors.indigo.withAlpha(80);
  static const double _iconSize = 16;
  static const double _dividerHeight = 20;
  static const TextStyle _textStyle = TextStyle(fontSize: 13);

  SortOptionsBar({
    super.key,
    required this.block,
    this.itemSpacing = 5,
    this.iconSpacing = 3,
  });

  @override
  Widget build(BuildContext context) {
    BlockComparator? blockComparator = block.blockComparator;
    //
    return BlockFragmentWidgetBuilder(
      ownerClassInstance: this,
      description: null,
      block: block,
      build: () {
        if (blockComparator == null) {
          return Text("[Sorting not supported]", style: _textStyle);
        }
        List<_SignAndPropName> sapnList = blockComparator._signAndPropNames;
        //
        return BreadCrumb(
          divider: _buildVerticalSeparator(),
          overflow: ScrollableOverflow(
            keepLastDivider: false,
            reverse: false,
            direction: Axis.horizontal,
          ),
          items: sapnList
              .map(
                (sapn) => _buildSortCriterion(blockComparator, sapn),
              )
              .toList(),
        );
      },
    );
  }

  BreadCrumbItem _buildSortCriterion(
      BlockComparator blockComparator, _SignAndPropName sapn) {
    return BreadCrumbItem(
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(sapn.propName, style: _textStyle),
          SizedBox(width: iconSpacing),
          _buildSortBtn(blockComparator, sapn),
        ],
      ),
    );
  }

  Widget _buildSortBtn(BlockComparator blockComparator, _SignAndPropName sapn) {
    return InkWell(
      child: _getSortIcon(sapn),
      onTap: () {
        SortSign nextSign = sapn.getNextSign();
        block.data.sort();
        block.updateAllUIComponents(withoutFilters: true);
      },
    );
  }

  Widget _getSortIcon(_SignAndPropName sapn) {
    if (sapn.isAsc()) {
      return Icon(
        cupertino.CupertinoIcons.sort_up,
        size: _iconSize,
      );
    } else if (sapn.isDesc()) {
      return Icon(
        cupertino.CupertinoIcons.sort_down,
        size: _iconSize,
      );
    } else {
      return Icon(
        cupertino.CupertinoIcons.line_horizontal_3,
        size: _iconSize,
      );
    }
  }

  Widget _buildVerticalSeparator() {
    return SizedBox(
      height: _dividerHeight,
      child: VerticalDivider(color: _dividerColor),
    );
  }
}
