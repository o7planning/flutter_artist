part of '../../core.dart';

class _ProzessDetermineNextStageExecutionUnit<
        STAGE_ENUM extends StageEnum, //
        PROZESS_INIT_DATA extends ProzessInitData,
        PROZESS_CONTEXT_DATA extends ProzessContextData>
    extends _ActivityMemberExecutionUnit {
  final XProzess xProzess;

  @override
  final ProzessDetermineNextStageIntent<
      STAGE_ENUM, //
      PROZESS_INIT_DATA,
      PROZESS_CONTEXT_DATA> executionIntent;

  _ProzessDetermineNextStageExecutionUnit({
    required this.xProzess,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.prozess,
          executionIntent: executionIntent,
        );

  @override
  Activity get activity => xProzess.prozess.activity;

  @override
  String getObjectName() {
    return xProzess.prozess.name;
  }

  @override
  Object get owner => xProzess.prozess;

  @override
  XActivity get xActivity => xProzess.xActivity;

  @override
  int get xModuleId => xProzess.xActivity.xModuleId;
}
