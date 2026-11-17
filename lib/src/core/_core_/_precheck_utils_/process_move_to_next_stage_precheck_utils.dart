part of '__precheck_utils.dart';

/// Utility class providing standalone precheck validations for stage navigation
/// within a [Prozess].
class ProzessStageNavigationPrecheckUtils {
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
        errCode: ProzessMoveToNextStagePrecheck.executorIsBusy,
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

  /// Evaluates whether the prozess can navigate back to the previous active stage.
  ///
  /// - [currentIndex]: The index of the current viewing stage within the active stages list (`-1` if not found).
  static Actionable<ProzessMoveToPreviousStagePrecheck>
  checkBeforeMoveToPreviousStage({
    required bool checkBusy,
    required bool isBusy,
    required bool hasViewingStage,
    required int currentIndex,
  }) {
    if (checkBusy && isBusy) {
      return Actionable.no(
        errCode: ProzessMoveToPreviousStagePrecheck.executorIsBusy,
      );
    }

    if (!hasViewingStage || currentIndex < 0) {
      return Actionable.no(
        errCode: ProzessMoveToPreviousStagePrecheck.noViewingStage,
      );
    }

    if (currentIndex <= 0) {
      return Actionable.no(
        errCode: ProzessMoveToPreviousStagePrecheck.noPreviousStage,
      );
    }

    return Actionable.yes();
  }
}