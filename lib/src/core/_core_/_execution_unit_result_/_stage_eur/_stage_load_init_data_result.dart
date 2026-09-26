part of '../../core.dart';

class StageLoadInitDataResult<
        STAGE_ENUM extends Enum, //
        INIT_DATA extends StageInitData,
        RESULT_DATA extends StageResultData,
        PROZESS_CONTEXT_DATA extends ProzessContextData>
    extends ExecutionUnitResult<StageLoadInitDataPrecheck> {
  StageLoadInitDataResult({required super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return errorInfo == null;
  }
}
