part of '../../core.dart';

class StageSubmitExecutionResult<
        STAGE_INIT_DATA extends StageInitData, //
        STAGE_RESULT_DATA extends StageResultData>
    extends ExecutionUnitResult<StageSubmitPrecheck> {
  StageSubmitExecutionResult({required super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return errorInfo == null;
  }
}
