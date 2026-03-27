import 'package:flutter/material.dart';
import 'package:flutter_artist_theme/flutter_artist_theme.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../_core_/core.dart';
import '_sorting_options.dart';
import '_tile.dart';
import 'breadcrumb_sort_panel_style.dart';

class BreadcrumbSortPanel<ITEM extends Object> extends SortPanel<ITEM>
    with SortPanelMixin {
  final BreadcrumbSortPanelStyle style;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;

  const BreadcrumbSortPanel({
    super.key,
    required super.sortModel,
    this.style = const BreadcrumbSortPanelStyle(),
    this.alignment,
    this.padding,
    this.decoration,
  });

  @override
  Widget buildContent(BuildContext context) {
    final tokens = context.faTokens;

    return Container(
      alignment: alignment,
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: decoration ??
          BoxDecoration(
            color: tokens.shortcut.surfaceColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(tokens.shortcut.borderRadius),
            border: Border.all(
                color: tokens.shortcut.border.color.withValues(alpha: 0.2)),
          ),
      child: BreadCrumb(
        divider: _buildSeparator(tokens.shortcut.border.color),
        items: sortModel.criteria
            .map((c) => _buildBreadCrumbItem(context, c, tokens))
            .toList(),
      ),
    );
  }

  BreadCrumbItem _buildBreadCrumbItem(
      BuildContext context, SortCriterion criterion, FaThemeTokens tokens) {
    return BreadCrumbItem(
      content: DragTarget<SortCriterion>(
        onWillAcceptWithDetails: (details) =>
            details.data.criterionName != criterion.criterionName,
        onAcceptWithDetails: (details) {
          sortModel.moveCriterion(
            movingCriterionName: details.data.criterionName,
            destCriterionName: criterion.criterionName,
          );
        },
        builder: (context, _, __) => Draggable<SortCriterion>(
          data: criterion,
          axis: Axis.horizontal,
          feedback: _buildDragFeedback(context, criterion, tokens),
          childWhenDragging: Opacity(
            opacity: 0.3,
            child: _buildCriterionView(context, criterion, false, tokens),
          ),
          child: _buildCriterionView(context, criterion, false, tokens),
        ),
      ),
    );
  }

  Widget _buildCriterionView(BuildContext context, SortCriterion criterion,
      bool isDragging, FaThemeTokens tokens) {
    final isActive = criterion.direction != null;

    return InkWell(
      onTap: () => toggleCriterionByName(sortModel, criterion),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              criterion.text,
              style: style.getTextStyle(context, isActive).copyWith(
                    color: isActive
                        ? tokens.shortcut.headerTextStyle.color
                        : tokens.shortcut.bodyTextStyle.color,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
            ),
            SizedBox(width: style.iconSpacing),
            buildSortButton(
              context: context,
              sortModel: sortModel,
              criterion: criterion,
              enabled: true,
              isDragging: isDragging,
              iconSize: style.sortIconSize,
              draggingColor:
                  style.draggingColor ?? tokens.shortcut.onSurfaceColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeparator(Color dividerColor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: style.itemSpacing),
      child: Text(
        '/',
        style: TextStyle(
          color: dividerColor.withValues(alpha: 0.5),
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildDragFeedback(
      BuildContext context, SortCriterion criterion, FaThemeTokens tokens) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: tokens.shortcut.surfaceColor.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(tokens.shortcut.borderRadius),
          boxShadow: tokens.shortcut.cardShadows,
          border: Border.all(color: tokens.shortcut.border.color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(criterion.text,
                style: tokens.shortcut.headerTextStyle.copyWith(fontSize: 14)),
            const SizedBox(width: 8),
            Icon(Icons.unfold_more_rounded,
                size: 16, color: tokens.shortcut.onSurfaceColor),
          ],
        ),
      ),
    );
  }
}
