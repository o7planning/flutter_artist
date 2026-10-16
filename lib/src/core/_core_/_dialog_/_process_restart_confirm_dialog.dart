part of '../core.dart';

enum _RestartConfirmMode { process, stage }

/// A dialog that confirms the restart of a Prozess or a specific Stage,
/// presenting a horizontal timeline to visualize the impact of the reset action.
class ProzessRestartConfirmDialog extends StatelessWidget {
  final Prozess prozess;
  final Stage? targetStage;
  final _RestartConfirmMode mode;

  const ProzessRestartConfirmDialog({
    super.key,
    required this.prozess,
    this.targetStage,
    required this.mode,
  });

  /// Displays the restart confirmation dialog and returns true if confirmed.
  static Future<bool> show({
    required BuildContext context,
    required Prozess prozess,
    Stage? targetStage,
    required _RestartConfirmMode mode,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProzessRestartConfirmDialog(
        prozess: prozess,
        targetStage: targetStage,
        mode: mode,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isProcessReset = mode == _RestartConfirmMode.process;
    final String title = isProcessReset ? "Restart Process" : "Restart Stage";
    final String message = isProcessReset
        ? "Are you sure you want to restart the entire process? All progress below will be cleared."
        : "Are you sure you want to restart this step? Data from this stage onward will be reset.";
    final IconData iconData = Icons.warning_amber_rounded;
    final Color actionColor = colorScheme.tertiary;

    return FaDialog(
      titleText: title,
      iconData: iconData,
      iconColor: actionColor,
      preferredContentWidth: 600,
      preferredContentHeight: null,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Warning message text
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),

          // 2. Horizontal timeline displaying stages
          _buildHorizontalTimeline(context),
        ],
      ),
      // 3. Action buttons matching FaConfirmDialog pattern
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            "Cancel",
            style: TextStyle(color: colorScheme.secondary),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: actionColor,
            foregroundColor: colorScheme.onPrimary,
            elevation: 0,
          ),
          child: const Text("Confirm Restart"),
        ),
      ],
    );
  }

  Widget _buildHorizontalTimeline(BuildContext context) {
    final stages = prozess.orderedStages;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(stages.length, (index) {
          final stage = stages[index];
          final bool isLast = index == stages.length - 1;

          // Determine which stages will be reset and which remain safe
          final bool willBeReset = isProcessReset(stage);

          return _buildTimelineNode(context, stage, isLast, willBeReset);
        }),
      ),
    );
  }

  bool isProcessReset(Stage stage) {
    if (mode == _RestartConfirmMode.process) return true;
    if (targetStage == null) return false;

    // For Stage restart, stages with order >= targetStage will be reset
    return stage.stageId.stageOrder >= targetStage!.stageId.stageOrder;
  }

  Widget _buildTimelineNode(
      BuildContext context, Stage stage, bool isLast, bool willBeReset) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isViewing = stage.isViewingStage;
    final bool isSubmitted = stage.isSubmitted;

    // 1. BASE LAYER: Determine the ACTUAL current state of the stage
    IconData baseIcon;
    Color baseColor;

    if (isSubmitted) {
      baseIcon = Icons.check_circle_rounded;
      baseColor = Colors.green.shade600;
    } else if (isViewing) {
      baseIcon = Icons.radio_button_checked_rounded;
      baseColor = colorScheme.primary;
    } else {
      baseIcon = Icons.radio_button_unchecked_rounded;
      baseColor = Colors.grey.shade400;
    }

    // 2. INDICATOR LAYER: Render the destructive marker above the node if it will be reset
    Widget topIndicator =
        const SizedBox(height: 24); // Fixed height placeholder
    if (willBeReset) {
      topIndicator = SizedBox(
        height: 24,
        child: RotatedBox(
          quarterTurns: 2, // Point downwards to the target node
          child: Icon(
            Icons.change_history_rounded,
            color: colorScheme.error, // Destructive red color
            size: 20,
          ),
        ),
      );
    }

    final Color dangerColor = colorScheme.error;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Node block
        SizedBox(
          width: 80, // Constrain width to force text wrapping
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // The warning/destruction indicator pointing to the node
              topIndicator,

              // The actual stage state icon
              Icon(baseIcon, color: baseColor, size: 28),
              const SizedBox(height: 8),

              // Stage Title
              Text(
                stage.stageId.displayTitle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isViewing ? FontWeight.bold : FontWeight.normal,
                  color: isViewing || isSubmitted
                      ? colorScheme.onSurface
                      : colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),

        // Horizontal connecting line
        if (!isLast)
          Container(
            // Align the line with the center of the 28px base icon (24px top space + 14px half icon - 1px half line)
            margin: const EdgeInsets.only(top: 37),
            width: 40,
            height: 2,
            color: willBeReset
                ? dangerColor.withValues(alpha: 0.3)
                : theme.dividerColor,
          ),
      ],
    );
  }
}
