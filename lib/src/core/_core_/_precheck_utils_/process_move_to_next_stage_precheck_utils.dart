part of '__precheck_utils.dart';

/// Utility class providing standalone precheck validations for stage navigation
/// within a [Prozess].
class ProzessMoveToNextStagePrecheckUtils {
  /// Evaluates whether the prozess can advance to the next active stage.
  ///
  /// - [currentIndex]: The index of the current viewing stage within the active stages list (`-1` if not found).
  /// - [activeStagesCount]: Total number of active stages in the workflow route.
  static Actionable<ProzessMoveToNextStagePrecheck> checkBeforeMoveToNextStage({
    required bool checkBusy,
    required bool isBusy,
    required bool hasViewingStage,
    required int currentIndex,
    required int activeStagesCount,
  }) {
    if (checkBusy && isBusy) {
      return Actionable.no(
        errCode: ProzessMoveToNextStagePrecheck.busy,
      );
    }

    if (!hasViewingStage || currentIndex < 0) {
      return Actionable.no(
        errCode: ProzessMoveToNextStagePrecheck.noViewingStage,
      );
    }

    if (currentIndex >= activeStagesCount - 1) {
      return Actionable.no(
        errCode: ProzessMoveToNextStagePrecheck.noNextStage,
      );
    }

    return Actionable.yes();
  }
}
