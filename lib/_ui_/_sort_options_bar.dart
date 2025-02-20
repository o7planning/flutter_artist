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
  static const double _dividerHeight = 20;

  SortOptionsBar({
    super.key,
    required this.block,
    this.itemSpacing = 5,
    this.iconSpacing = 3,
    this.textStyle = const TextStyle(fontSize: 14),
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
    BlockItemComparator? blockComparator = block.itemComparator;
    //
    return BlockFragmentWidgetBuilder(
      ownerClassInstance: this,
      description: null,
      block: block,
      build: () {
        if (blockComparator == null) {
          return Text("[Sorting not supported]", style: textStyle);
        }
        List<_SortSignAndPropName> sapnList = blockComparator._signAndPropNames;
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
      BlockItemComparator blockComparator, _SortSignAndPropName sapn) {
    return BreadCrumbItem(
      content: DragTarget<_SortSignAndPropName>(
        hitTestBehavior: HitTestBehavior.deferToChild,
        onWillAcceptWithDetails:
            (DragTargetDetails<_SortSignAndPropName> details) {
          if (details.data.propName == sapn.propName) {
            return false;
          }
          return true;
        },
        onAcceptWithDetails:
            (DragTargetDetails<_SortSignAndPropName> dragTarget) {
          blockComparator.movePropName(
            movingPropName: dragTarget.data.propName,
            destPropName: sapn.propName,
          );
          block.updateAllUIComponents(withoutFilters: true);
        },
        builder: (
          BuildContext context,
          List<_SortSignAndPropName?> candidateData,
          List<dynamic> rejectedData,
        ) {
          return Draggable<_SortSignAndPropName>(
            data: sapn,
            feedback: _buildDragFeedback(
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

  Widget _buildDragFeedback({
    required BlockItemComparator blockComparator,
    required _SortSignAndPropName signAndPropName,
  }) {
    return Icon(
      Icons.video_file,
      size: 16,
      color: Colors.indigo,
    );
  }

  Widget _builSortCriterionView({
    required BlockItemComparator blockComparator,
    required _SortSignAndPropName signAndPropName,
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
          block: block,
          blockComparator: blockComparator,
          signAndPropName: signAndPropName,
          isDragging: isDragging,
        ),
      ],
    );
  }

  Widget _buildVerticalSeparator() {
    return SizedBox(
      height: _dividerHeight,
      child: VerticalDivider(color: _dividerColor),
    );
  }
}
