part of '../core.dart';

sealed class StageExecutionIntent<
        STAGE_ENUM extends Enum,
        STAGE_DATA extends StageData,
        FLOW_CONTEXT_DATA extends FlowContextData,
        PRECHECK, //
        EXECUTION_RESULT extends ExecutionUnitResult<PRECHECK>>
    extends ExecutionIntent {
  //
}

class StageSubmitExecutionIntent<
    STAGE_ENUM extends Enum, //
    STAGE_DATA extends StageData,
    FLOW_CONTEXT_DATA extends FlowContextData> extends StageExecutionIntent<
    STAGE_ENUM, //
    STAGE_DATA,
    FLOW_CONTEXT_DATA,
    StageSubmitPrecheck,
    StageSubmitResult> {
  //
}
