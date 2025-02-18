part of '../flutter_artist.dart';

class ComparisonBar extends StatelessWidget {
  final Block block;
  final double itemSpacing;
  final double iconSpacing;

  final Color _dividerColor = Colors.indigo.withAlpha(80);
  static const double _iconSize = 16;
  static const double _dividerHeight = 20;
  static const TextStyle _textStyle = TextStyle(fontSize: 13);

  ComparisonBar({
    super.key,
    required this.block,
    this.itemSpacing = 5,
    this.iconSpacing = 3,
  });

  @override
  Widget build(BuildContext context) {
    BlockComparator? blockComparator = block.blockComparator;
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
            (sapn) => _buildSortCriterion(sapn),
          )
          .toList(),
    );
  }

  BreadCrumbItem _buildSortCriterion(_SignAndPropName sapn) {
    return BreadCrumbItem(
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(sapn.propName, style: _textStyle),
          SizedBox(width: iconSpacing),
          _getSortIcon(sapn),
        ],
      ),
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
