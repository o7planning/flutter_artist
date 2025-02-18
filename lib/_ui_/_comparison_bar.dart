part of '../flutter_artist.dart';

class ComparisonBar extends StatelessWidget {
  final Block block;

  final Color _dividerColor = Colors.indigo.withAlpha(80);
  static const double _dividerHeight = 20;
  static const TextStyle _textStyle = TextStyle(fontSize: 13);

  ComparisonBar({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    BlockComparator? blockComparator = block.data.blockComparator;
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
          _getSortIcon(sapn),
        ],
      ),
    );
  }

  Icon _getSortIcon(_SignAndPropName sapn) {
    if (sapn.isAsc()) {
      return Icon(cupertino.CupertinoIcons.sort_up);
    } else if (sapn.isDesc()) {
      return Icon(cupertino.CupertinoIcons.sort_down);
    } else {
      return Icon(cupertino.CupertinoIcons.line_horizontal_3);
    }
  }

  Widget _buildVerticalSeparator() {
    return SizedBox(
      height: _dividerHeight,
      child: VerticalDivider(color: _dividerColor),
    );
  }
}
