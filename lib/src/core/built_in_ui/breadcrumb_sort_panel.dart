import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../_core_/core.dart';
import '_sorting_options.dart';

class BreadcrumbSortPanel<ITEM extends Object> extends SortPanel<ITEM> {
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

  BreadcrumbSortPanel({
    super.key,
    required super.sortModel,
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

  BreadcrumbSortPanel.simple({
    super.key,
    required super.sortModel,
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
        items: sortModel.criteria
            .map(
              (criterion) => _buildBreadCrumbItem(
                criterion,
              ),
            )
            .toList(),
      ),
    );
  }

  BreadCrumbItem _buildBreadCrumbItem(SortCriterion criterion) {
    return BreadCrumbItem(
      content: DragTarget<SortCriterion>(
        hitTestBehavior: HitTestBehavior.deferToChild,
        onWillAcceptWithDetails: (DragTargetDetails<SortCriterion> details) {
          if (details.data.criterionNameX == criterion.criterionNameX) {
            return false;
          }
          return true;
        },
        onAcceptWithDetails: (DragTargetDetails<SortCriterion> details) {
          sortModel.moveCriterion(
            movingCriterionName: details.data.criterionNameX,
            destCriterionName: criterion.criterionNameX,
          );
        },
        builder: (
          BuildContext context,
          List<SortCriterion?> candidateData,
          List<dynamic> rejectedData,
        ) {
          return Draggable<SortCriterion>(
            data: criterion,
            feedback: _buildDragFeedback(criterion),
            childWhenDragging: _buildSortingCriterionView(
              sortCriterion: criterion,
              isDragging: true,
            ),
            onDragCompleted: () {
              // Do nothing.
            },
            child: _buildSortingCriterionView(
              sortCriterion: criterion,
              isDragging: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildDragFeedback(SortCriterion sortingCriterion) {
    return Icon(
      Icons.video_file,
      size: 16,
      color: Colors.indigo,
    );
  }

  Widget _buildSortingCriterionView({
    required SortCriterion sortCriterion,
    required bool isDragging,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          sortCriterion.text,
          style: isDragging //
              ? textStyle.copyWith(color: Colors.grey)
              : textStyle,
        ),
        SizedBox(width: iconSpacing),
        buildSortBtn(
          sortModel: sortModel,
          sortCriterion: sortCriterion,
          isDragging: isDragging,
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
