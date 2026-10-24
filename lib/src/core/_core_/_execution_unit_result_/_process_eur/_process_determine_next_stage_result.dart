part of '../../core.dart';

class ProzessDetermineNextStageResult<
STAGE_ENUM extends StageEnum, //
PROZESS_INIT_DATA extends ProzessInitData,
PROZESS_CONTEXT_DATA extends ProzessContextData>
    extends ExecutionUnitResult<ProzessDetermineNextStagePrecheck> {
  ProzessDetermineNextStageResult({required super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return errorInfo == null;
  }
}
