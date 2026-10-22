part of '__precheck_utils.dart';

class StageRestartPrecheckUtils {
  static Actionable<StageRestartPrecheck> checkBeforeRestartStage({
    required bool checkBusy,
    required bool isBusy,
    required Stage? targetStage,
    required bool isRestartAllowed,
  }) {
    if (checkBusy && isBusy) {
      return Actionable<StageRestartPrecheck>.no(
        errCode: StageRestartPrecheck.busy,
      );
    }

    if (targetStage == null) {
      return Actionable<StageRestartPrecheck>.no(
        errCode: StageRestartPrecheck.noTargetStage,
      );
    }

    if (!isRestartAllowed) {
      return Actionable<StageRestartPrecheck>.no(
        errCode: StageRestartPrecheck.notAllowed,
      );
    }

    return Actionable<StageRestartPrecheck>.yes();
  }
}
