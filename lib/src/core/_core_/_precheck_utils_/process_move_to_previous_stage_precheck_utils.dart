part of '__precheck_utils.dart';

/// Utility class providing standalone precheck validations for stage navigation
/// within a [Prozess].
class ProzessMoveToPreviousStagePrecheckUtils {
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
        errCode: ProzessMoveToPreviousStagePrecheck.busy,
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
