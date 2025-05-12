part of '../../flutter_artist.dart';

class SortOptionsBar extends StatelessWidget {
  final Block _block;
  final double itemSpacing;
  final double iconSpacing;

  //
  final TextStyle textStyle;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final double? width;
  final double? height;
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
    required Block block,
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
  }) : _block = block;

  SortOptionsBar.simple({
    super.key,
    required Block block,
    this.itemSpacing = 5,
    this.iconSpacing = 3,
    this.textStyle = const TextStyle(fontSize: 14),
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
  })
      : _block = block,
        decoration = BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.4),
        );

  @override
  Widget build(BuildContext context) {
    ItemSortCriteria? itemSortCriteria = _block.itemSortCriteria;
    //
    return BlockFragmentViewBuilder(
      ownerClassInstance: this,
      description: null,
      block: _block,
      build: () {
        if (itemSortCriteria == null) {
          return Text("[Sorting not supported]", style: textStyle);
        }
        List<SortCriterion> criteria = itemSortCriteria._criteria;
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
            items: criteria
                .map(
                  (criterion) =>
                  _buildBreadCrumbItem(
                    itemSortCriteria,
                    criterion,
                  ),
            )
                .toList(),
          ),
        );
      },
    );
  }

  BreadCrumbItem _buildBreadCrumbItem(ItemSortCriteria itemSortCriteria,
      SortCriterion criterion,) {
    return BreadCrumbItem(
      content: DragTarget<SortCriterion>(
        hitTestBehavior: HitTestBehavior.deferToChild,
        onWillAcceptWithDetails: (DragTargetDetails<SortCriterion> details) {
          if (details.data.propName == criterion.propName) {
            return false;
          }
          return true;
        },
        onAcceptWithDetails: (DragTargetDetails<SortCriterion> details) {
          itemSortCriteria.moveCriterion(
            movingCriterion: details.data,
            destCriterion: criterion,
          );
          _block.updateAllUIComponents(
            withoutFilters: true,
            force: true,
          );
        },
        builder: (BuildContext context,
            List<SortCriterion?> candidateData,
            List<dynamic> rejectedData,) {
          return Draggable<SortCriterion>(
            data: criterion,
            feedback: _buildDragFeedback(
              itemSortCriteria: itemSortCriteria,
              sortCriterion: criterion,
            ),
            childWhenDragging: _builSortCriterionView(
              itemSortCriteria: itemSortCriteria,
              sortCriterion: criterion,
              isDragging: true,
            ),
            onDragCompleted: () {
              // Do nothing.
            },
            child: _builSortCriterionView(
              itemSortCriteria: itemSortCriteria,
              sortCriterion: criterion,
              isDragging: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildDragFeedback({
    required ItemSortCriteria itemSortCriteria,
    required SortCriterion sortCriterion,
  }) {
    return Icon(
      Icons.video_file,
      size: 16,
      color: Colors.indigo,
    );
  }

  Widget _builSortCriterionView({
    required ItemSortCriteria itemSortCriteria,
    required SortCriterion sortCriterion,
    required bool isDragging,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          sortCriterion.text,
          style:
          isDragging ? textStyle.copyWith(color: Colors.grey) : textStyle,
        ),
        SizedBox(width: iconSpacing),
        _buildSortBtn(
          itemSortCriteria: itemSortCriteria,
          sortCriterion: sortCriterion,
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
