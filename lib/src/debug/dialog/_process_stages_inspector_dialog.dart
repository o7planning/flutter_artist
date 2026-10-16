import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/widgets/class_linked_button.dart';

/// A diagnostic dialog that inspects and lists all stages of a [Prozess]
/// across individual rows, highlighting current viewing, frontier, and execution states,
/// with an optimized layout to prevent text overflow on stage states.
class ProzessStagesInspectorDialog extends StatelessWidget {
  final Prozess prozess;

  const ProzessStagesInspectorDialog({
    required this.prozess,
    super.key,
  });

  /// Opens the prozess stages inspector dialog.
  static Future<void> show({
    required BuildContext context,
    required Prozess prozess,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => ProzessStagesInspectorDialog(
        prozess: prozess,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final List<Stage> stages = prozess.orderedStages;

    return FaDialog(
      titleText: "Prozess Pipeline Inspector",
      iconData: FaIconConstants.prozessIconData,
      preferredContentWidth: 560,
      preferredContentHeight: null,
      contentPadding: const EdgeInsets.all(8),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Prozess Metadata Header
            Text(
              "PROZESS DEFINITION",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 8),

            // Prozess Details
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProzessNameRow(context, prozess),
                  const SizedBox(height: 4),
                  _buildMetadataRow(context, "Name:", prozess.name),
                  const SizedBox(height: 4),
                  _buildProzessStateRow(context, prozess),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Divider(
                height: 1,
                thickness: 0.5,
                color: theme.dividerColor.withValues(alpha: 0.3)),
            const SizedBox(height: 12),

            // Stages List Header
            Text(
              "Stages (${stages.length}):",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),

            // Stages Row List
            if (stages.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    "No stages configured in this prozess.",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
              )
            else
              ...stages.map((stage) => _buildStageRow(context, stage)),
          ],
        ),
      ),
    );
  }

  Widget _buildProzessNameRow(BuildContext context, Prozess prozess) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 105,
          child: Text(
            "Prozess:",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
        Expanded(
          child: ClassLinkedButton(
            targetObject: prozess,
            dialogTitle: "Prozess Class Definition",
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildProzessStateRow(BuildContext context, Prozess prozess) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 105,
          child: Text(
            "Prozess State:",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
        Expanded(
          child: SelectableText(
            prozess.dataState.toBriefInfo(),
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetadataRow(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 105,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
        Expanded(
          child: SelectableText(
            value,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStageRow(BuildContext context, Stage stage) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isViewing = stage.isViewingStage;
    final bool isFrontier = stage.isFrontierStage;
    final bool isSubmitted = stage.isSubmitted;
    final StageDataState dataState = stage.dataState;

    IconData indicatorIcon;
    Color indicatorColor;

    if (isSubmitted) {
      indicatorIcon = Icons.check_circle_rounded;
      indicatorColor = Colors.green.shade600;
    } else if (isViewing) {
      indicatorIcon = Icons.visibility_rounded;
      indicatorColor = colorScheme.primary;
    } else if (isFrontier) {
      indicatorIcon = Icons.flag_rounded;
      indicatorColor = Colors.orange.shade800;
    } else {
      indicatorIcon = Icons.radio_button_unchecked_rounded;
      indicatorColor = Colors.grey.shade400;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isViewing
            ? colorScheme.primaryContainer.withValues(alpha: 0.15)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isViewing
              ? colorScheme.primary.withValues(alpha: 0.4)
              : theme.dividerColor.withValues(alpha: 0.15),
          width: isViewing ? 1.2 : 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Status Indicator Icon
            Icon(
              indicatorIcon,
              size: 18,
              color: indicatorColor,
            ),
            const SizedBox(width: 10),

            // Stage Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Class Name (via ClassLinkedButton) & Badges
                  Row(
                    children: [
                      ClassLinkedButton(
                        targetObject: stage,
                        dialogTitle: "Stage Class Definition",
                        fontSize: 13,
                      ),
                      if (isViewing) ...[
                        const SizedBox(width: 6),
                        _buildBadge(context, "VIEWING", colorScheme.primary),
                      ],
                      if (isFrontier) ...[
                        const SizedBox(width: 6),
                        _buildBadge(
                            context, "FRONTIER", Colors.orange.shade800),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Row 2: Stage Code & State
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Row(
                      children: [
                        Text(
                          stage.stageId.stageCode,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color: colorScheme.secondary,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: stage.hasError
                              ? () => stage.showStageErrorViewerDialog(context)
                              : null,
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: indicatorColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: indicatorColor.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              dataState.toBriefInfo(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: indicatorColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
