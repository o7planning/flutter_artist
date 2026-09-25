part of '../../core.dart';

class _StageSubmitExecutionUnit<
STAGE_ENUM extends Enum, //
STAGE_DATA extends StageData,
FLOW_CONTEXT_DATA extends FlowContextData>
    extends _ActivityMemberExecutionUnit {
  final XStage xStage;

  @override
  final StageSubmitExecutionIntent<
      STAGE_ENUM, //
      STAGE_DATA,
      FLOW_CONTEXT_DATA> executionIntent;

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
  XActivity get xActivity => xStage.xFlow.xActivity;

  @override
  int get xActivityId => xStage.xFlow.xActivity.xActivityId;
}
