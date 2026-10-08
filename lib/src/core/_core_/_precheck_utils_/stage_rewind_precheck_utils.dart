part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for prozess stage rewind operations.
class StageRewindPrecheckUtils {
  /// Evaluates whether a prozess is permitted to rewind its frontier back to the target stage
  /// based on execution busyness, re-execution policies, and stage completion states.
  static Actionable<StageRewindPrecheck> checkBeforeRewindFrontierToStage({
    required bool checkBusy,
    required bool isBusy,
    required int? targetStageOrder,
    required bool hasTargetStage,
    required bool targetStageIsSubmitted,
    required bool reexecutionAllowed,
  }) {
    // 1. Priority 1: Check if the global executor is busy
    if (checkBusy && isBusy) {
      return Actionable<StageRewindPrecheck>.no(
        errCode: StageRewindPrecheck.busy,
      );
    }

    // 2. Priority 2: Ensure target stage exists
    if (!hasTargetStage || targetStageOrder == null) {
      return Actionable<StageRewindPrecheck>.no(
        errCode: StageRewindPrecheck.noTargetStage,
      );
    }

    // 3. Priority 3: Check if stage re-execution is permitted by prozess configuration
    if (!reexecutionAllowed) {
      return Actionable<StageRewindPrecheck>.no(
        errCode: StageRewindPrecheck.reexecutionNotAllowed,
      );
    }

    // 4. Priority 4: Ensure target stage has already been submitted (can't rewind to unreached/unsubmitted stage)
    if (!targetStageIsSubmitted) {
      return Actionable<StageRewindPrecheck>.no(
        errCode: StageRewindPrecheck.stageNotSubmittedYet,
      );
    }

    return Actionable<StageRewindPrecheck>.yes();
  }
}
