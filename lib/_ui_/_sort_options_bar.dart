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
                  (sapn) => _buildBreadCrumbItem(blockComparator, sapn),
                )
                .toList(),
          ),
        );
      },
    );
  }

  BreadCrumbItem _buildBreadCrumbItem(
      BlockComparator blockComparator, _SignAndPropName sapn) {
    return BreadCrumbItem(
      content: DragTarget<_SignAndPropName>(
        hitTestBehavior: HitTestBehavior.deferToChild,
        onWillAcceptWithDetails: (DragTargetDetails<_SignAndPropName> details) {
          if (details.data.propName == sapn.propName) {
            return false;
          }
          return true;
        },
        onAcceptWithDetails: (DragTargetDetails<_SignAndPropName> dragTarget) {
          blockComparator.movePropName(
            movingPropName: dragTarget.data.propName,
            destPropName: sapn.propName,
          );
          block.updateAllUIComponents(withoutFilters: true);
        },
        builder: (
          BuildContext context,
          List<_SignAndPropName?> candidateData,
          List<dynamic> rejectedData,
        ) {
          return Draggable<_SignAndPropName>(
            data: sapn,
            feedback: _buildFeedback(
              blockComparator: blockComparator,
              signAndPropName: sapn,
            ),
            childWhenDragging: _builSortCriterionView(
              blockComparator: blockComparator,
              signAndPropName: sapn,
              isDragging: true,
            ),
            onDragCompleted: () {
              // Do nothing.
            },
            child: _builSortCriterionView(
              blockComparator: blockComparator,
              signAndPropName: sapn,
              isDragging: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeedback({
    required BlockComparator blockComparator,
    required _SignAndPropName signAndPropName,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: _builSortCriterionView(
          blockComparator: blockComparator,
          signAndPropName: signAndPropName,
          isDragging: false,
        ),
      ),
    );
  }

  Widget _builSortCriterionView({
    required BlockComparator blockComparator,
    required _SignAndPropName signAndPropName,
    required bool isDragging,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          signAndPropName.propName,
          style:
              isDragging ? textStyle.copyWith(color: Colors.grey) : textStyle,
        ),
        SizedBox(width: iconSpacing),
        _buildSortBtn(
          blockComparator: blockComparator,
          signAndPropName: signAndPropName,
          isDragging: isDragging,
        ),
      ],
    );
  }

  Widget _buildSortBtn({
    required BlockComparator blockComparator,
    required _SignAndPropName signAndPropName,
    required bool isDragging,
  }) {
    return InkWell(
      child: _getSortIcon(signAndPropName, isDragging),
      onTap: () {
        SortSign nextSign = signAndPropName.getNextSign();
        _SignAndPropName updateSapn = signAndPropName.copyWith(nextSign);
        blockComparator._updateSignAndPropName(updateSapn);
        block.data.sort();
        block.updateAllUIComponents(withoutFilters: true);
      },
    );
  }

  Widget _getSortIcon(_SignAndPropName sapn, bool isDragging) {
    Color? color = isDragging ? Colors.grey : null;
    if (sapn.isAsc()) {
      return Icon(
        cupertino.CupertinoIcons.sort_up,
        size: _iconSize,
        color: color,
      );
    } else if (sapn.isDesc()) {
      return Icon(
        cupertino.CupertinoIcons.sort_down,
        size: _iconSize,
        color: color,
      );
    } else {
      return Icon(
        cupertino.CupertinoIcons.line_horizontal_3,
        size: _iconSize,
        color: color,
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
