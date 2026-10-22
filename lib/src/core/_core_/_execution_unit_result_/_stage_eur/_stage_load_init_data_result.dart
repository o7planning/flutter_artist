part of '../../core.dart';

class StageRestartResult<
STAGE_ENUM extends StageEnum, //
INIT_DATA extends StageInitData,
RESULT_DATA extends StageResultData,
PROZESS_CONTEXT_DATA extends ProzessContextData>
    extends ExecutionUnitResult<StageRestartPrecheck> {
  StageRestartResult({required super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return errorInfo == null;
  }
}
