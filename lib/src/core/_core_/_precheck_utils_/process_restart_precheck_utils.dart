part of '__precheck_utils.dart';

class ProzessRestartPrecheckUtils {
  static Actionable<ProzessRestartPrecheck> checkBeforeRestart({
    required bool checkBusy,
    required bool isBusy,
  }) {
    if (checkBusy && isBusy) {
      return Actionable<ProzessRestartPrecheck>.no(
        errCode: ProzessRestartPrecheck.busy,
      );
    }
    return Actionable<ProzessRestartPrecheck>.yes();
  }
}
