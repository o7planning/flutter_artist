import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../enums/_enums.dart';

/// Utility class responsible for validating the integrity and logical order
/// of the determined next stage enum within a prozess pipeline.
class CheckNextStageUtils {
  /// Validates whether the [determinedNextStageEnum] is valid relative to the current [viewingStageEnum].
  ///
  /// Throws an [AppError] if:
  /// - No initial stage is determined when starting from a null viewing stage.
  /// - The determined next stage has an order less than or equal to the current viewing stage (preventing backward loops).
  static void checkDeterminedNextStage<STAGE_ENUM extends StageEnum>({
    required STAGE_ENUM? viewingStageEnum,
    required STAGE_ENUM? determinedNextStageEnum,
  }) {
    // Case 1: Starting fresh with no active viewing stage pointer.
    if (viewingStageEnum == null) {
      if (determinedNextStageEnum == null) {
        throw AppError(
          errorMessage:
              "Pipeline Error: No initial stage could be determined to commence the prozess.",
        );
      }
    }
    // Case 2: Progressing forward from an active viewing stage pointer.
    else {
      if (determinedNextStageEnum != null &&
          determinedNextStageEnum.stageOrder <= viewingStageEnum.stageOrder) {
        throw AppError(
          errorMessage:
              "Pipeline Architectural Violation: The determined next stage order "
              "(${determinedNextStageEnum.stageOrder}) must be strictly greater than the current "
              "viewing stage order (${viewingStageEnum.stageOrder}). Backward stage transitions are not permitted.",
        );
      }
    }
  }
}
