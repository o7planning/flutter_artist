part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for block backend action operations.
class BlockBackendActionPrecheckUtils {
  /// Evaluates whether executing a backend action on the block is permitted.
  static Actionable<BlockBackendActionPrecheck>
      checkBeforeExecuteBackendAction({
    required bool checkBusy,
    required bool isBusy,
    required BlockDataState blockDataState,
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
        return Actionable<BlockBackendActionPrecheck>.yes();
    }
  }
}
