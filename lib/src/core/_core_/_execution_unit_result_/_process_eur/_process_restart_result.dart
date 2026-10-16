part of '../../core.dart';

class ProzessRestartResult<
        STAGE_ENUM extends StageEnum, //
        PROZESS_INIT_DATA extends ProzessInitData,
        PROZESS_CONTEXT_DATA extends ProzessContextData>
    extends ExecutionUnitResult<ProzessRestartPrecheck> {
  ProzessRestartResult({required super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return errorInfo == null;
  }
}
