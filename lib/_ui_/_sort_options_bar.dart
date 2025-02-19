part of '../flutter_artist.dart';

class SortOptionsBar extends StatelessWidget {
  final Block block;
  final double itemSpacing;
  final double iconSpacing;

  //
  final TextStyle textStyle;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  Decoration? decoration;
  final Decoration? foregroundDecoration;
  final double? width;
  double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;

  //
  final Color _dividerColor = Colors.indigo.withAlpha(80);
  static const double _iconSize = 16;
  static const double _dividerHeight = 20;

  SortOptionsBar({
    super.key,
    required this.block,
    this.itemSpacing = 5,
    this.iconSpacing = 3,
    this.textStyle = const TextStyle(fontSize: 13),
    //
    this.alignment,
    this.padding,
    this.decoration,
    this.foregroundDecoration,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none,
  });

  SortOptionsBar.simple({
    super.key,
    required this.block,
    this.itemSpacing = 5,
    this.iconSpacing = 3,
    this.textStyle = const TextStyle(fontSize: 13),
    //
    this.alignment,
    this.padding = const EdgeInsets.all(5),
    this.foregroundDecoration,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none,
  }) : decoration = BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.4),
        );

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
          return Text("[Sorting not supported]", style: textStyle);
        }
        List<_SignAndPropName> sapnList = blockComparator._signAndPropNames;
        //
        return Container(
          alignment: alignment,
          padding: padding,
          decoration: decoration,
          foregroundDecoration: foregroundDecoration,
          width: width,
          height: height,
          constraints: constraints,
          margin: margin,
          transform: transform,
          transformAlignment: transformAlignment,
          clipBehavior: clipBehavior,
          child: BreadCrumb(
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
          ),
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
          Text(sapn.propName, style: textStyle),
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
        _SignAndPropName updateSapn = sapn.copyWith(nextSign);
        blockComparator._updateSignAndPropName(updateSapn);
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
