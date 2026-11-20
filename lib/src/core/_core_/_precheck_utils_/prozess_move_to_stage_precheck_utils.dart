part of '__precheck_utils.dart';

/// Utility class providing pure precheck validation for navigating a [Prozess]
/// directly to a specified stage.
class ProzessMoveToStagePrecheckUtils {
  /// Evaluates whether the prozess is permitted to jump to [targetStage].
  static Actionable<ProzessMoveToStagePrecheck> checkBeforeMoveToStage({
    required bool checkBusy,
    required bool isBusy,
    required bool isTargetStageInActiveRoute,
  }) {
    // 1. Priority 1: Check if the global executor is busy
    if (checkBusy && isBusy) {
      return Actionable<ProzessMoveToStagePrecheck>.no(
        errCode: ProzessMoveToStagePrecheck.busy,
      );
    }

    // 2. Priority 2: Ensure target stage belongs to the active route
    if (!isTargetStageInActiveRoute) {
      return Actionable<ProzessMoveToStagePrecheck>.no(
        errCode: ProzessMoveToStagePrecheck.stageNotInActiveRoute,
      );
    }

    return Actionable<ProzessMoveToStagePrecheck>.yes();
  }
}
