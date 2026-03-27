import 'package:flutter/material.dart';
import 'package:flutter_artist_theme/flutter_artist_theme.dart';

import '../_core_/core.dart';
import '../enums/_sort_direction.dart';
import '_sorting_options.dart';
import '_tile.dart';
import 'dropdown_sort_panel_style.dart';

/// A sort panel using a standard DropdownButton.
class DropdownSortPanel<ITEM extends Object> extends SortPanel<ITEM>
    with SortPanelMixin {
  final DropdownSortPanelStyle style;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? margin;

  const DropdownSortPanel({
    super.key,
    required super.sortModel,
    this.style = const DropdownSortPanelStyle(),
    this.alignment,
    this.margin,
  });

  @override
  Widget buildContent(BuildContext context) {
    final tokens = context.faTokens;
    final theme = Theme.of(context);

    final selected = sortModel.findFirstCriterionHasDirection() ??
        (sortModel.criteria.isNotEmpty ? sortModel.criteria.first : null);
    final bool hasActiveSort = selected?.direction != null;

    return Container(
      alignment: alignment,
      margin: margin,
      decoration: style.decoration ??
          BoxDecoration(
            color: tokens.shortcut.surfaceColor,
            border: Border.fromBorderSide(tokens.shortcut.border),
            borderRadius:
                BorderRadius.circular(tokens.shortcut.borderRadius / 2),
            boxShadow: tokens.shortcut.cardShadows,
          ),
      padding: style.padding,
      height: 36,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SortCriterion>(
          value: selected,
          isDense: true,
          dropdownColor: tokens.shortcut.surfaceColor,
          borderRadius: BorderRadius.circular(tokens.shortcut.borderRadius),
          icon: Icon(
            style.dropdownIcon,
            size: style.dropdownIconSize,
            color: hasActiveSort
                ? theme.primaryColor
                : tokens.shortcut.onSurfaceColor.withValues(alpha: 0.6),
          ),
          onChanged: (_) {},
          items: sortModel.criteria.map((criterion) {
            final isActive = criterion == selected;
            return DropdownMenuItem<SortCriterion>(
              value: criterion,
              onTap: () => _handleDropdownChanged(criterion),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    criterion.text,
                    style: style.getTextStyle(context, isActive).copyWith(
                          color: isActive
                              ? theme.primaryColor
                              : tokens.shortcut.onSurfaceColor,
                        ),
                  ),
                  const SizedBox(width: 8),
                  defaultSortIcon(
                    context,
                    criterion.direction,
                    false,
                    style.sortIconSize,
                    null,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _handleDropdownChanged(SortCriterion? criterion) {
    if (criterion == null) return;

    final currentActive = sortModel.findFirstCriterionHasDirection();

    SortDirection nextDirection;
    if (currentActive?.criterionName == criterion.criterionName) {
      nextDirection = (criterion.direction == SortDirection.asc)
          ? SortDirection.desc
          : SortDirection.asc;
    } else {
      nextDirection = criterion.direction ??
          criterion.lastUsedDirection ??
          criterion.initialDirection ??
          SortDirection.asc;
    }

    sortModel.updateSortingCriterionByName(
      criterionName: criterion.criterionName,
      direction: nextDirection,
      moveToFirst: false,
    );
  }
}
