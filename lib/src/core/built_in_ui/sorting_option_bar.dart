import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../_core_/core.dart';
import '_sorting_options.dart';

class SortingOptionBar<ITEM extends Object> extends SortView<ITEM> {
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
    required super.sortingModel,
    required super.sortingSide,
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

  SortingOptionBar.simple({
    super.key,
    required super.sortingModel,
    required super.sortingSide,
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
  }) : decoration = BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.4),
        );

  @override
  Widget buildContent(BuildContext context) {
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
        items: sortingModel.criteria
            .map(
              (criterion) => _buildBreadCrumbItem(
                criterion,
              ),
            )
            .toList(),
      ),
    );
  }

  BreadCrumbItem _buildBreadCrumbItem(SortingCriterion criterion) {
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
          sortingModel.ui.updateAllUIComponents(
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
            feedback: _buildDragFeedback(criterion),
            childWhenDragging: _buildSortingCriterionView(
              sortingCriterion: criterion,
              isDragging: true,
            ),
            onDragCompleted: () {
              // Do nothing.
            },
            child: _buildSortingCriterionView(
              sortingCriterion: criterion,
              isDragging: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildDragFeedback(SortingCriterion sortingCriterion) {
    return Icon(
      Icons.video_file,
      size: 16,
      color: Colors.indigo,
    );
  }

  Widget _buildSortingCriterionView({
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
        buildSortBtn(
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
