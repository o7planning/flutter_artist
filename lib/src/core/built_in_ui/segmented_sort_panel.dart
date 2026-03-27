import 'package:flutter/material.dart';
import 'package:flutter_artist_theme/flutter_artist_theme.dart';

import '../_core_/core.dart';
import '_sorting_options.dart';
import '_tile.dart';
import 'segmented_sort_panel_style.dart';

/// A Material 3 segmented sort panel with drag-and-drop support.
class SegmentedSortPanel<ITEM extends Object> extends SortPanel<ITEM>
    with SortPanelMixin {
  final SegmentedSortPanelStyle style;

  const SegmentedSortPanel({
    super.key,
    required super.sortModel,
    this.style = const SegmentedSortPanelStyle(),
  });

  @override
  Widget buildContent(BuildContext context) {
    final tokens = context.faTokens;
    final theme = Theme.of(context);
    final selected = sortModel.findFirstCriterionHasDirection();

    return Padding(
      padding: style.padding,
      child: Theme(
        data: theme.copyWith(
          segmentedButtonTheme: SegmentedButtonThemeData(
            style: SegmentedButton.styleFrom(
              visualDensity: style.visualDensity,
              tapTargetSize: style.tapTargetSize,
              backgroundColor: tokens.shortcut.surfaceColor,
              selectedBackgroundColor:
                  theme.primaryColor.withValues(alpha: 0.1),
              foregroundColor: tokens.shortcut.onSurfaceColor,
              selectedForegroundColor: theme.primaryColor,
              side: BorderSide(
                color: tokens.shortcut.border.color.withValues(alpha: 0.5),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(tokens.shortcut.borderRadius / 2),
              ),
            ),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SegmentedButton<SortCriterion>(
            emptySelectionAllowed: true,
            segments: sortModel.criteria.map((criterion) {
              final isActive = criterion == selected;
              return ButtonSegment<SortCriterion>(
                value: criterion,
                label: _buildDraggableSegment(context, criterion, isActive),
              );
            }).toList(),
            selected: selected != null ? {selected} : {},
            onSelectionChanged: (Set<SortCriterion> newSelection) {
              if (newSelection.isNotEmpty) {
                toggleCriterionByName(sortModel, newSelection.first);
              } else if (selected != null) {
                toggleCriterionByName(sortModel, selected);
              }
            },
            showSelectedIcon: false,
          ),
        ),
      ),
    );
  }

  /// Builds the draggable label with localized refresh support.
  Widget _buildDraggableSegment(
      BuildContext context, SortCriterion criterion, bool isActive) {
    return DragTarget<SortCriterion>(
      onWillAcceptWithDetails: (details) =>
          details.data.criterionName != criterion.criterionName,
      onAcceptWithDetails: (details) {
        sortModel.moveCriterion(
            movingCriterionName: details.data.criterionName,
            destCriterionName: criterion.criterionName);
      },
      builder: (context, _, __) => Draggable<SortCriterion>(
        data: criterion,
        axis: Axis.horizontal,
        feedback: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4)
                ],
              ),
              child: Text(criterion.text, style: style.textStyle),
            )),
        // Use the common getTextStyle and buildSortButton.
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(criterion.text, style: style.getTextStyle(context, isActive)),
            SizedBox(width: style.iconSpacing),
            // The icon itself shouldn't trigger toggle here to avoid conflict with SegmentedButton's onTap.
            buildSortButton(
                context: context,
                sortModel: sortModel,
                criterion: criterion,
                enabled: false,
                isDragging: false,
                iconSize: style.sortIconSize,
                draggingColor: style.draggingColor),
          ],
        ),
      ),
    );
  }
}
