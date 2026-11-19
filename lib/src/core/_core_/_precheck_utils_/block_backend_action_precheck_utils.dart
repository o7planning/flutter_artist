part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for block backend action operations.
class BlockBackendActionPrecheckUtils {
  /// Evaluates whether executing a block backend action is permitted based on
  /// system busy state, block data state, and business permission rules.
  static Actionable<BlockBackendActionPrecheck>
      checkBeforeExecuteBackendAction({
    required bool checkBusy,
    required bool isBusy,
    required BlockDataState blockDataState,
    required bool checkAllow,
    required CheckAllowResult Function() checkBackendActionAllowed,
  }) {
    // 1. Priority 1: Check if the system executor is busy
    if (checkBusy && isBusy) {
      return Actionable<BlockBackendActionPrecheck>.no(
        errCode: BlockBackendActionPrecheck.busy,
      );
    }

    // 2. Priority 2: Check Block DataState constraints
    switch (blockDataState) {
      case BlockDataStateNone():
        return Actionable<BlockBackendActionPrecheck>.no(
          errCode: BlockBackendActionPrecheck.blockInNoneState,
        );
      case BlockDataStatePending():
        return Actionable<BlockBackendActionPrecheck>.no(
          errCode: BlockBackendActionPrecheck.blockInPendingState,
        );
      case BlockDataStateLoadedStale():
        return Actionable<BlockBackendActionPrecheck>.no(
          errCode: BlockBackendActionPrecheck.blockInStaleState,
        );
      case BlockDataStateLoadedFresh():
        break;
    }

    // 3. Priority 3: Check business permission rules
    if (checkAllow) {
      final CheckAllowResult result = checkBackendActionAllowed();
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockBackendActionPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockBackendActionPrecheck>.no(
            errCode: BlockBackendActionPrecheck.notAllowed,
          );
        case CheckAllow.error:
          return Actionable<BlockBackendActionPrecheck>.no(
            errCode: BlockBackendActionPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }

    return Actionable<BlockBackendActionPrecheck>.yes();
  }
}
