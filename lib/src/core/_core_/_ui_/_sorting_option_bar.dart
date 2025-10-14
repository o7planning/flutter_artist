part of '../core.dart';

class SortingOptionBar extends StatelessWidget {
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

  SortingOptionBar({
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

  SortingOptionBar.simple({
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
  })  : _block = block,
        decoration = BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.4),
        );

  @override
  Widget build(BuildContext context) {
    SortingModel? sortingModel = _block.sortingModel;
    //
    return BlockFragmentViewBuilder(
      ownerClassInstance: this,
      description: null,
      block: _block,
      build: () {
        if (sortingModel == null) {
          return Text("[Sorting not supported]", style: textStyle);
        }
        List<SortingCriterion> criteria = sortingModel._criteria;
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
                  (criterion) => _buildBreadCrumbItem(
                    sortingModel,
                    criterion,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  BreadCrumbItem _buildBreadCrumbItem(
    SortingModel sortingModel,
    SortingCriterion criterion,
  ) {
    return BreadCrumbItem(
      content: DragTarget<SortingCriterion>(
        hitTestBehavior: HitTestBehavior.deferToChild,
        onWillAcceptWithDetails: (DragTargetDetails<SortingCriterion> details) {
          if (details.data.criterionName == criterion.criterionName) {
            return false;
          }
          return true;
        },
        onAcceptWithDetails: (DragTargetDetails<SortingCriterion> details) {
          sortingModel.moveCriterion(
            movingCriterion: details.data,
            destCriterion: criterion,
          );
          _block.ui.updateAllUIComponents(
            withoutFilters: true,
            force: true,
          );
        },
        builder: (
          BuildContext context,
          List<SortingCriterion?> candidateData,
          List<dynamic> rejectedData,
        ) {
          return Draggable<SortingCriterion>(
            data: criterion,
            feedback: _buildDragFeedback(
              sortingModel: sortingModel,
              sortingCriterion: criterion,
            ),
            childWhenDragging: _builSortingCriterionView(
              sortingModel: sortingModel,
              sortingCriterion: criterion,
              isDragging: true,
            ),
            onDragCompleted: () {
              // Do nothing.
            },
            child: _builSortingCriterionView(
              sortingModel: sortingModel,
              sortingCriterion: criterion,
              isDragging: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildDragFeedback({
    required SortingModel sortingModel,
    required SortingCriterion sortingCriterion,
  }) {
    return Icon(
      Icons.video_file,
      size: 16,
      color: Colors.indigo,
    );
  }

  Widget _builSortingCriterionView({
    required SortingModel sortingModel,
    required SortingCriterion sortingCriterion,
    required bool isDragging,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          sortingCriterion.text,
          style: isDragging //
              ? textStyle.copyWith(color: Colors.grey)
              : textStyle,
        ),
        SizedBox(width: iconSpacing),
        _buildSortBtn(
          sortingModel: sortingModel,
          sortingCriterion: sortingCriterion,
          isDragging: isDragging,
          acceptNoneDirection: true,
          enabled: true,
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
