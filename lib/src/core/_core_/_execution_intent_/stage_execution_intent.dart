part of '../core.dart';

sealed class StageExecutionIntent<
        STAGE_ENUM extends Enum,
        STAGE_INIT_DATA extends StageInitData,
        STAGE_RESULT_DATA extends StageResultData,
        PROZESS_CONTEXT_DATA extends ProzessContextData,
        PRECHECK, //
        EXECUTION_RESULT extends ExecutionUnitResult<PRECHECK>>
    extends ExecutionIntent {
  //
}

class StageLoadInitDataIntent<
    STAGE_ENUM extends Enum, //
    STAGE_INIT_DATA extends StageInitData,
    STAGE_RESULT_DATA extends StageResultData,
    PROZESS_CONTEXT_DATA extends ProzessContextData> extends StageExecutionIntent<
    STAGE_ENUM, //
    STAGE_INIT_DATA,
    STAGE_RESULT_DATA,
    PROZESS_CONTEXT_DATA,
    StageLoadInitDataPrecheck,
    StageLoadInitDataResult> {
  //
}

class StageSubmitExecutionIntent<
    STAGE_ENUM extends Enum, //
    STAGE_INIT_DATA extends StageInitData,
    STAGE_RESULT_DATA extends StageResultData,
    PROZESS_CONTEXT_DATA extends ProzessContextData> extends StageExecutionIntent<
    STAGE_ENUM, //
    STAGE_INIT_DATA,
    STAGE_RESULT_DATA,
    PROZESS_CONTEXT_DATA,
    StageSubmitPrecheck,
    StageSubmitResult> {
  //
}
