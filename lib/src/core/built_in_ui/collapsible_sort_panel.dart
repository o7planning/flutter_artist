import 'package:flutter/material.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';

import '../_core_/core.dart';
import '_menu_item.dart';
import '_sort_panel_helper.dart';
import '_sorting_options.dart';
import '_style.dart';
import 'collapsible_sort_panel_style.dart';

class CollapsibleSortPanel<ITEM extends Object> extends SortPanel<ITEM>
    with SortPanelMixin {
  final CollapsibleSortPanelStyle style;
  final MainAxisAlignment alignment;
  final double minFullWidth;

  const CollapsibleSortPanel({
    super.key,
    required super.sortModel,
    this.style = const CollapsibleSortPanelStyle(),
    this.alignment = MainAxisAlignment.start,
    this.minFullWidth = 450,
  });

  @override
  Widget buildContent(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: style.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: (constraints.maxWidth > minFullWidth)
                ? _buildHorizontalToolbar(context)
                : _buildCollapsedMenu(context),
          );
        },
      ),
    );
  }

  Widget _buildCollapsedMenu(BuildContext context) {
    final tokens = context.faTheme.tokens;

    final activeCriterion =
        sortModel.findFirstCriterionHasDirection() ?? sortModel.criteria.first;
    final bool hasActiveSort = activeCriterion.direction != null;

    return Container(
      key: const ValueKey('collapsed'),
      alignment: AlignmentDirectional.centerStart,
      padding: style.padding,
      child: PopupMenuButton<void>(
        offset: const Offset(0, 40),
        color: SortPanelHelper.getBackgroundColor(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radius.sm),
          side: SortPanelHelper.getBorder(context),
        ),
        child: Container(
          height: style.height,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: SortPanelHelper.getBackgroundColor(context),
            border: Border.fromBorderSide(SortPanelHelper.getBorder(context)),
            borderRadius: BorderRadius.circular(tokens.radius.sm),
            boxShadow: context.faTheme.shadow.card,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                activeCriterion.text,
                style: style.getTextStyle(context, hasActiveSort).copyWith(
                      color:
                          SortPanelHelper.getTextColor(context, hasActiveSort),
                    ),
              ),
              const SizedBox(width: 8),
              buildSortButton(
                context: context,
                sortModel: sortModel,
                criterion: activeCriterion,
                enabled: false,
                isDragging: false,
                iconSize: style.sortIconSize,
                draggingColor: style.draggingColor,
              ),
            ],
          ),
        ),
        itemBuilder: (context) => [
          PopupMenuItem<void>(
            enabled: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: sortModel.criteria
                  .map((c) => SortMenuItem(
                        criterion: c,
                        sortModel: sortModel,
                        style: style,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalToolbar(BuildContext context) {
    final tokens = context.faTheme.tokens;
    return Container(
      key: const ValueKey('horizontal'),
      alignment: AlignmentDirectional.centerStart,
      padding: EdgeInsets.zero, // style.padding.copyWith(left: 0),
      child: ClipRect(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: style.height,
          decoration: BoxDecoration(
            color: SortPanelHelper.getBackgroundColor(context),
            border: Border.fromBorderSide(SortPanelHelper.getBorder(context)),
            borderRadius: BorderRadius.circular(tokens.radius.sm),
            boxShadow: context.faTheme.shadow.card,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < sortModel.criteria.length; i++) ...[
                  _buildToolbarItem(context, sortModel.criteria[i]),
                  if (i != sortModel.criteria.length - 1)
                    _buildDivider(context),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: style.buttonSpacing / 2),
      width: 1,
      height: 14,
      color: SortPanelHelper.getBorder(context).color.withValues(alpha: 0.6),
    );
  }

  Widget _buildToolbarItem(BuildContext context, SortCriterion criterion) {
    final isActive = criterion.direction != null;
    final tokens = context.faTheme.tokens;

    return InkWell(
      borderRadius: BorderRadius.circular(tokens.radius.sm),
      onTap: () => toggleCriterionByName(sortModel, criterion),
      hoverColor:
          SortPanelHelper.getTextColor(context, true).withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(criterion.text,
                style: style
                    .getTextStyle(context, isActive)
                    .copyWith(fontSize: 12)),
            const SizedBox(width: 4),
            buildSortButton(
              context: context,
              sortModel: sortModel,
              criterion: criterion,
              enabled: true,
              isDragging: false,
              iconSize: style.sortIconSize,
              draggingColor: style.draggingColor,
            ),
          ],
        ),
      ),
    );
  }
}
