part of '../core.dart';

sealed class ProzessExecutionIntent<
        STAGE_ENUM extends StageEnum, //
        PROZESS_INIT_DATA extends ProzessInitData,
        PROZESS_CONTEXT_DATA extends ProzessContextData,
        PRECHECK, //
        EXECUTION_RESULT extends ExecutionUnitResult<PRECHECK>>
    extends ExecutionIntent<PRECHECK, EXECUTION_RESULT> {
  ProzessExecutionIntent();
}

class ProzessLoadInitDataIntent<
        STAGE_ENUM extends StageEnum, //
        PROZESS_INIT_DATA extends ProzessInitData,
        PROZESS_CONTEXT_DATA extends ProzessContextData>
    extends ProzessExecutionIntent<
        STAGE_ENUM, //
        PROZESS_INIT_DATA,
        PROZESS_CONTEXT_DATA,
        ProzessLoadInitDataPrecheck,
        ProzessLoadInitDataResult<STAGE_ENUM, PROZESS_INIT_DATA,
            PROZESS_CONTEXT_DATA>> {
  ProzessLoadInitDataIntent();
}

class ProzessDetermineNextStageIntent<
        STAGE_ENUM extends StageEnum, //
        PROZESS_INIT_DATA extends ProzessInitData,
        PROZESS_CONTEXT_DATA extends ProzessContextData>
    extends ProzessExecutionIntent<
        STAGE_ENUM, //
        PROZESS_INIT_DATA,
        PROZESS_CONTEXT_DATA,
        ProzessDetermineNextStagePrecheck,
        ProzessDetermineNextStageResult<STAGE_ENUM, PROZESS_INIT_DATA,
            PROZESS_CONTEXT_DATA>> {
  // final PROZESS_INIT_DATA prozessInitData;

  ProzessDetermineNextStageIntent(// {required this.prozessInitData}
      );
}

class ProzessDoneIntent<
        STAGE_ENUM extends StageEnum, //
        PROZESS_INIT_DATA extends ProzessInitData,
        PROZESS_CONTEXT_DATA extends ProzessContextData>
    extends ProzessExecutionIntent<
        STAGE_ENUM, //
        PROZESS_INIT_DATA,
        PROZESS_CONTEXT_DATA,
        dynamic,
        EmptyExecutionUnitResult> {
  final String lastIntentInfo;

  ProzessDoneIntent({required this.lastIntentInfo});
}

class ProzessNullIntent<
        STAGE_ENUM extends StageEnum, //
        PROZESS_INIT_DATA extends ProzessInitData,
        PROZESS_CONTEXT_DATA extends ProzessContextData>
    extends ProzessExecutionIntent<
        STAGE_ENUM, //
        PROZESS_INIT_DATA,
        PROZESS_CONTEXT_DATA,
        dynamic,
        EmptyExecutionUnitResult> {
  final String lastIntentInfo;

  ProzessNullIntent({required this.lastIntentInfo});
}
