part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for application backend action operations.
class StorageBackendActionPrecheckUtils {
  /// Evaluates whether executing an application backend action is permitted.
  static Actionable<StorageBackendActionPrecheck>
      checkBeforeExecuteStorageBackendAction({
    required bool checkBusy,
    required bool isBusy,
  }) {
    // 1. Priority 1: Check if the system executor is busy
    if (checkBusy && isBusy) {
      return Actionable<StorageBackendActionPrecheck>.no(
        errCode: StorageBackendActionPrecheck.busy,
      );
    }

    return Actionable<StorageBackendActionPrecheck>.yes();
  }
}
