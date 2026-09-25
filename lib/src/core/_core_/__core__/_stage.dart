part of '../core.dart';

abstract class Stage<
        STAGE_ENUM extends Enum,
        STAGE_DATA extends StageData,
        FLOW_CONTEXT_DATA extends FlowContextData,
        FORM_INPUT extends FormInput,
        ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData>
    extends _Core {
  final STAGE_ENUM stageId;
  final String name;
  final StageConfig config;
  final StageEffectiveConfig effectiveConfig;

  final StageFormModel<
      STAGE_ENUM, //
      STAGE_DATA,
      FLOW_CONTEXT_DATA, //
      FORM_INPUT,
      ADDITIONAL_FORM_RELATED_DATA>? formModel;

  late final Flow<STAGE_ENUM, FLOW_CONTEXT_DATA> flow;

  StageDataState _dataState = StageDataStateNone();

  StageDataState get dataState => _dataState;

  Activity get activity => flow.activity;

  late final ui = _StageUiComponents(stage: this);

  Stage({
    required this.stageId,
    required this.name,
    this.config = const StageConfig(),
    this.formModel,
  }) : effectiveConfig = StageEffectiveConfig.fromConfig(config) {
    formModel?._bindToStage(this);
  }

  // ***************************************************************************

  XStage<
      STAGE_ENUM, //
      STAGE_DATA,
      FLOW_CONTEXT_DATA,
      FORM_INPUT,
      ADDITIONAL_FORM_RELATED_DATA> _createXStage({
    required XFlow xFlow,
  }) {
    return XStage<STAGE_ENUM, STAGE_DATA, FLOW_CONTEXT_DATA, FORM_INPUT,
        ADDITIONAL_FORM_RELATED_DATA>._(
      stage: this,
      xFlow: xFlow,
    );
  }

  // ***************************************************************************

  void _bindToFlow(Flow<STAGE_ENUM, dynamic> parentFlow) {
    flow = parentFlow as Flow<STAGE_ENUM, FLOW_CONTEXT_DATA>;
  }

  bool get hasError {
    // TODO: implement hasMountedUiComponent
    throw UnimplementedError();
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> execute() async {
    // TODO:...
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _unitSubmit({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XStage<
            STAGE_ENUM, //
            STAGE_DATA,
            FLOW_CONTEXT_DATA,
            FORM_INPUT,
            ADDITIONAL_FORM_RELATED_DATA>
        thisXStage,
    required StageSubmitExecutionIntent<Enum, StageData, FlowContextData>
        executionIntent,
  }) async {
    //
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<ApiResult<StageExecutionResult<STAGE_ENUM, STAGE_DATA>>>
      performStageSubmit({
    required Map<String, dynamic> formStageData,
    required FLOW_CONTEXT_DATA sharedContext,
  });

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _processStageSubmitResult(
      ApiResult<StageExecutionResult<STAGE_ENUM, STAGE_DATA>> apiResult) async {
    if (apiResult.isError()) {
      // _dataState = StageDataState;
      return;
    }
    final result = apiResult.data;
    if (result != null) {
      // _dataState = StageDataState.loaded;
      flow._processStageSubmitResult(result);
    }
  }

  void showStageErrorViewerDialog(BuildContext context) {
    // TODO:
  }
}
