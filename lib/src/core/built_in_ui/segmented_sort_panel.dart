import 'package:flutter/material.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';

import '../_core_/core.dart';
import '_sort_panel_helper.dart';
import '_sorting_options.dart';
import '_style.dart';
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
              backgroundColor: SortPanelHelper.getBackgroundColor(context),
              foregroundColor: SortPanelHelper.getTextColor(context, false),
              selectedBackgroundColor:
                  SortPanelHelper.getTextColor(context, true)
                      .withValues(alpha: 0.1),
              selectedForegroundColor:
                  SortPanelHelper.getTextColor(context, true),
              side: SortPanelHelper.getBorder(context),
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
                color: SortPanelHelper.getBackgroundColor(context)
                    .withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(4),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4)
                ],
                border:
                    Border.fromBorderSide(SortPanelHelper.getBorder(context)),
              ),
              child: Text(criterion.text,
                  style: style.textStyle.copyWith(
                      color: SortPanelHelper.getTextColor(context, false))),
            )),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(criterion.text, style: style.getTextStyle(context, isActive)),
            SizedBox(width: style.iconSpacing),
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
