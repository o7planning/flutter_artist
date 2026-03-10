import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../_core_/core.dart';
import '_sorting_options.dart';
import 'breadcrumb_sort_panel_style.dart';

class BreadcrumbSortPanel<ITEM extends Object> extends SortPanel<ITEM> {
  final BreadcrumbSortPanelStyle style;

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

  const BreadcrumbSortPanel({
    super.key,
    required super.sortModel,
    this.style = const BreadcrumbSortPanelStyle(),
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

  const BreadcrumbSortPanel.simple({
    super.key,
    required super.sortModel,
    this.style = const BreadcrumbSortPanelStyle(),
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
  }) : decoration = const BoxDecoration(
          border: Border.fromBorderSide(
            BorderSide(color: Colors.grey, width: 0.4),
          ),
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
        divider: _buildSeparator(),
        overflow: ScrollableOverflow(
          keepLastDivider: false,
          reverse: false,
          direction: Axis.horizontal,
        ),
        items: sortModel.criteria
            .map((criterion) => _buildBreadCrumbItem(context, criterion))
            .toList(),
      ),
    );
  }

  BreadCrumbItem _buildBreadCrumbItem(
    BuildContext context,
    SortCriterion criterion,
  ) {
    return BreadCrumbItem(
      content: DragTarget<SortCriterion>(
        hitTestBehavior: HitTestBehavior.deferToChild,
        onWillAcceptWithDetails: (details) =>
            details.data.criterionName != criterion.criterionName,
        onAcceptWithDetails: (details) {
          sortModel.moveCriterion(
            movingCriterionName: details.data.criterionName,
            destCriterionName: criterion.criterionName,
          );
        },
        builder: (context, candidateData, rejectedData) {
          return Draggable<SortCriterion>(
            data: criterion,
            feedback: _buildDragFeedback(),
            childWhenDragging: _buildCriterionView(context, criterion, true),
            child: _buildCriterionView(context, criterion, false),
          );
        },
      ),
    );
  }

  Widget _buildDragFeedback() {
    return Material(
      color: Colors.transparent,
      child: Icon(
        style.dragFeedbackIcon,
        size: 20,
        color: style.dragFeedbackColor,
      ),
    );
  }

  Widget _buildCriterionView(
    BuildContext context,
    SortCriterion criterion,
    bool isDragging,
  ) {
    final textStyle = isDragging
        ? (style.draggingTextStyle ??
            style.textStyle.copyWith(color: Colors.grey))
        : style.textStyle;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(criterion.text, style: textStyle),
        SizedBox(width: style.iconSpacing),
        buildSortButton(
          context: context,
          sortModel: sortModel,
          criterion: criterion,
          enabled: true,
          isDragging: isDragging,
          iconSize: 16,
          draggingColor: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildSeparator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: style.itemSpacing),
      child: SizedBox(
        height: style.dividerHeight,
        child: VerticalDivider(
          color: style.dividerColor,
          thickness: style.dividerThickness,
        ),
      ),
    );
  }
}
