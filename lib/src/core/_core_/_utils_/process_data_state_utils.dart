import '../../error/_process_error_info.dart';
import '../core.dart';

/// Utility calculator responsible for safely resolving lifecycle state transitions
/// for a [Prozess] when errors occur during initialization or context resolution.
class ProzessDataStateUtils {
  /// Calculates the next [ProzessDataState] upon encountering an operational error during initialization.
  static ProzessDataState calculateDataStateOnLoadInitDataError({
    required ProzessDataState currentDataState,
    required ProzessErrorInfo errorInfo,
    required bool hasExistingInitData,
  }) {
    // If valid init data was previously loaded, preserve screen stability by marking state as stale.
    if (hasExistingInitData) {
      return ProzessDataStateLoadedStale(staleErrorInfo: errorInfo);
    }

    // Otherwise, fallback to a cold pending failure state.
    return ProzessDataStatePending.failed(errorInfo: errorInfo);
  }

  /// Calculates the next [ProzessDataState] when an error occurs during next-stage determination (determineNextStage).
  static ProzessDataState calculateDataStateOnDetermineNextStageError({
    required ProzessDataState currentDataState,
    required ProzessErrorInfo errorInfo,
  }) {
    // Transition into a failed transition state, preserving diagnostic error info
    // to allow error viewers or retry mechanisms to handle it.
    return ProzessDataStateTransitionFailed(
      transitionErrorInfo: errorInfo,
    );
  }
}
