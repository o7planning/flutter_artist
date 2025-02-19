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
        onWillAcceptWithDetails: (DragTargetDetails<_SignAndPropName> details) {
          print(">>>> onWillAcceptWithDetails");
          if (details.data.propName == sapn.propName) {
            print(">>>> false");
            return false;
          }
          return true;
        },
        onAcceptWithDetails: (DragTargetDetails<_SignAndPropName> dragTarget) {
          print(
              ">>>> movingPropName: ${dragTarget.data.propName} --> ${sapn.propName}");
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
          print("Chay vao day: $candidateData - rejectedData: $rejectedData");
          return Draggable<_SignAndPropName>(
            feedback: _buildFeedback(blockComparator, sapn),
            childWhenDragging: Container(),
            onDragCompleted: () {
              // onDragInitiativeCompleted(
              //   initiative: initiative,
              //   newStatusCode: initiative.status.code,
              // );
              // blockComparator.movePropName(
              //   movingPropName: dragTarget.data.propName,
              //   destPropName: sapn.propName,
              // );
              // block.updateAllUIComponents(withoutFilters: true);

              print("candidateData: ${candidateData}");
            },
            child: _builSortCriterionView(blockComparator, sapn),
          );
        },
      ),
    );
  }

  Widget _buildFeedback(
      BlockComparator blockComparator, _SignAndPropName sapn) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: _builSortCriterionView(
          blockComparator,
          sapn,
        ),
      ),
    );
  }

  Widget _builSortCriterionView(
      BlockComparator blockComparator, _SignAndPropName sapn) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(sapn.propName, style: textStyle),
        SizedBox(width: iconSpacing),
        _buildSortBtn(blockComparator, sapn),
      ],
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
