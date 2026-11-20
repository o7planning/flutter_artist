part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for shelf deferred event executions.
class ShelfDeferredEventPrecheckUtils {
  /// Evaluates whether a shelf is permitted to execute deferred external reactions.
  ///
  /// - [checkBusy] & [isBusy]: Enforces system-wide busy check.
  static Actionable<ShelfDeferredEventExecutionPrecheck>
      checkBeforeExecuteDelayedExternalReaction({
    required bool checkBusy,
    required bool isBusy,
  }) {
    if (checkBusy && isBusy) {
      return Actionable<ShelfDeferredEventExecutionPrecheck>.no(
        errCode: ShelfDeferredEventExecutionPrecheck.busy,
      );
    }

    return Actionable<ShelfDeferredEventExecutionPrecheck>.yes();
  }
}
