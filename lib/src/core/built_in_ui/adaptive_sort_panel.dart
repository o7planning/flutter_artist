import 'package:flutter/material.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';

import '../_core_/core.dart';
import '_menu_item.dart';
import '_sort_panel_helper.dart';
import '_sorting_options.dart';
import '_style.dart';
import 'adaptive_sort_panel_style.dart';

/// A smart sort panel that displays as many items as possible horizontally,
/// collapsing the rest into a stateful overflow menu.
class AdaptiveSortPanel<ITEM extends Object> extends SortPanel<ITEM>
    with SortPanelMixin {
  final AdaptiveSortPanelStyle style;

  const AdaptiveSortPanel({
    super.key,
    required super.sortModel,
    this.style = const AdaptiveSortPanelStyle(),
  });

  @override
  Widget buildContent(BuildContext context) {
    final tokens = context.faTheme.tokens;

    return SizedBox(
      width: double.maxFinite,
      height: style.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double availableWidth = constraints.maxWidth;
          final List<SortCriterion> criteria = sortModel.criteria;
          const double moreButtonWidth = 135.0;
          final double dividerWidth = 17.0;

          int visibleCount = 0;
          double currentUsedWidth = 0;
          bool showMore = false;

          for (int i = 0; i < criteria.length; i++) {
            double itemWidth = style.itemEstimatedWidth;
            double neededWidth = currentUsedWidth + itemWidth;
            if (i > 0) neededWidth += dividerWidth;

            if (neededWidth <= availableWidth) {
              currentUsedWidth = neededWidth;
              visibleCount++;
            } else {
              showMore = true;
              break;
            }
          }

          if (showMore || visibleCount < criteria.length) {
            showMore = true;
            visibleCount = 0;
            currentUsedWidth = 0;
            for (int i = 0; i < criteria.length; i++) {
              double itemWidth = style.itemEstimatedWidth;
              double neededWidthWithMore = currentUsedWidth +
                  itemWidth +
                  style.itemSpacing +
                  moreButtonWidth;
              if (i > 0) neededWidthWithMore += dividerWidth;

              if (neededWidthWithMore <= availableWidth) {
                currentUsedWidth += itemWidth;
                if (i > 0) currentUsedWidth += dividerWidth;
                visibleCount++;
              } else {
                break;
              }
            }
          }

          final visibleItems = criteria.take(visibleCount).toList();
          final hiddenItems = criteria.skip(visibleCount).toList();

          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (visibleItems.isNotEmpty)
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: SortPanelHelper.getBackgroundColor(context),
                      border: Border.fromBorderSide(
                          SortPanelHelper.getBorder(context)),
                      borderRadius:
                          BorderRadius.circular(tokens.radius.borderRadius),
                      boxShadow: context.faTheme.shadow.card,
                    ),
                    child: ClipRect(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int i = 0; i < visibleItems.length; i++) ...[
                              _buildToolbarItem(context, visibleItems[i]),
                              if (i != visibleItems.length - 1)
                                _buildDivider(context),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              if (showMore) ...[
                SizedBox(width: style.itemSpacing),
                _buildMoreMenu(context, hiddenItems),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildMoreMenu(BuildContext context, List<SortCriterion> hiddenItems) {
    final tokens = context.faTheme.tokens;
    final theme = Theme.of(context);

    final activeInHidden = hiddenItems.firstWhere(
      (c) => c.direction != null,
      orElse: () => hiddenItems.first,
    );
    final bool hasActiveSort = activeInHidden.direction != null;

    return PopupMenuButton<void>(
      padding: EdgeInsets.zero,
      offset: const Offset(0, 40),
      color: SortPanelHelper.getBackgroundColor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radius.sm),
        side: SortPanelHelper.getBorder(context),
      ),
      child: Container(
        height: style.height,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: SortPanelHelper.getBackgroundColor(context),
          border: Border.fromBorderSide(SortPanelHelper.getBorder(context)),
          borderRadius: BorderRadius.circular(tokens.radius.sm),
          boxShadow: context.faTheme.shadow.popup,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              activeInHidden.text,
              style: style.getTextStyle(context, hasActiveSort).copyWith(
                    fontSize: 13,
                    color: SortPanelHelper.getTextColor(context, hasActiveSort),
                  ),
            ),
            if (hasActiveSort) ...[
              const SizedBox(width: 6),
              buildSortButton(
                context: context,
                sortModel: sortModel,
                criterion: activeInHidden,
                enabled: false,
                isDragging: false,
                iconSize: style.sortIconSize,
                draggingColor: style.draggingColor,
                iconBuilder: style.iconBuilder,
              ),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Container(
                width: 1,
                height: 12,
                color: SortPanelHelper.getIconColor(context, false),
              ),
            ),
            Icon(
              Icons.more_vert_rounded,
              size: 16,
              color: SortPanelHelper.getIconColor(context, false),
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem<void>(
          enabled: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: hiddenItems
                .map((c) => SortMenuItem(
                      criterion: c,
                      sortModel: sortModel,
                      style: style,
                      iconBuilder: style.iconBuilder,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 1,
      height: 14,
      color: SortPanelHelper.getBorder(context).color,
    );
  }

  Widget _buildToolbarItem(BuildContext context, SortCriterion criterion) {
    final isActive = criterion.direction != null;
    return InkWell(
      onTap: () => toggleCriterionByName(sortModel, criterion),
      // Logic from Mixin
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(criterion.text, style: style.getTextStyle(context, isActive)),
            SizedBox(width: style.iconSpacing),
            buildSortButton(
              context: context,
              sortModel: sortModel,
              criterion: criterion,
              enabled: true,
              isDragging: false,
              iconSize: style.sortIconSize,
              draggingColor: style.draggingColor,
              iconBuilder: style.iconBuilder,
            ),
          ],
        ),
      ),
    );
  }
}
