part of '__precheck_utils.dart';

class StageLoadInitDataPrecheckUtils {
  /// Evaluates whether the stage is permitted to load or reload its initial data
  /// based on system business rules, stage state, and effective configuration.
  static Actionable<StageLoadInitDataPrecheck> checkBeforeLoadInitData({
    required bool checkBusy,
    required bool isBusy,
    required int? targetStageOrder,
    required int? viewingStageOrder,
    required int? frontierStageOrder,
    required StageDataState targetStageDataState,
    required bool reexecutionAllowed,
  }) {
    // 1. Priority 1: Check if the global executor is busy
    if (checkBusy && isBusy) {
      return Actionable<StageLoadInitDataPrecheck>.no(
        errCode: StageLoadInitDataPrecheck.busy,
      );
    }

    // 2. Priority 2: Ensure target stage order is specified
    if (targetStageOrder == null) {
      return Actionable<StageLoadInitDataPrecheck>.no(
        errCode: StageLoadInitDataPrecheck.noTargetStage,
      );
    }

    // 3. Priority 3: Ensure target stage is currently the active viewing stage
    if (targetStageOrder != viewingStageOrder) {
      return Actionable<StageLoadInitDataPrecheck>.no(
        errCode: StageLoadInitDataPrecheck.isNotViewingStage,
      );
    }

    return Actionable<StageLoadInitDataPrecheck>.yes();
  }
}
