part of '../../core.dart';

class _StageSubmitExecutionUnit<
        STAGE_ENUM extends Enum, //
        STAGE_INIT_DATA extends StageInitData,
        STAGE_RESULT_DATA extends StageResultData,
        PROZESS_CONTEXT_DATA extends ProzessContextData>
    extends _ActivityMemberExecutionUnit {
  final XStage xStage;

  @override
  final StageSubmitIntent<
      STAGE_ENUM, //
      STAGE_INIT_DATA,
      STAGE_RESULT_DATA,
      PROZESS_CONTEXT_DATA> executionIntent;

  _StageSubmitExecutionUnit({
    required this.xStage,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.stage,
          executionIntent: executionIntent,
        );

  @override
  Activity get activity => xStage.stage.activity;

  @override
  String getObjectName() {
    return xStage.stage.name;
  }

  @override
  Object get owner => xStage.stage;

  @override
  XActivity get xActivity => xStage.xProzess.xActivity;

  @override
  int get xModuleId => xStage.xProzess.xActivity.xModuleId;
}
