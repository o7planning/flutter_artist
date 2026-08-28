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
  final StageFormModel<STAGE_DATA, FORM_INPUT, ADDITIONAL_FORM_RELATED_DATA>?
      formModel;

  late final Flow<STAGE_ENUM, FLOW_CONTEXT_DATA> flow;
  StageDataState _dataState = StageDataState.idle;
  StageDataState get dataState => _dataState;

  Activity get activity => flow.activity;

  late final _StageUiComponents ui = _StageUiComponents(stage: this);

  Stage({
    required this.stageId,
    required this.name,
    this.config = const StageConfig(),
    this.formModel,
  }) : effectiveConfig = StageEffectiveConfig.fromConfig(config) {
    formModel?._bindToStage(this);
  }

  void _bindToFlow(Flow<STAGE_ENUM, dynamic> parentFlow) {
    flow = parentFlow as Flow<STAGE_ENUM, FLOW_CONTEXT_DATA>;
  }

  bool get hasError {
    // TODO: implement hasMountedUiComponent
    throw UnimplementedError();
  }

  /// Thực thi hành động Submit của riêng bước này.
  Future<ApiResult<StageExecutionResult<STAGE_ENUM, STAGE_DATA>>>
      performStageSubmit({
    required Map<String, dynamic> formStageData,
    required FLOW_CONTEXT_DATA sharedContext,
  });

  /// Nhận kết quả và chuyển giao cho Flow điều phối.
  Future<void> _processStageSubmitResult(
      ApiResult<StageExecutionResult<STAGE_ENUM, STAGE_DATA>> apiResult) async {
    if (apiResult.isError()) {
      _dataState = StageDataState.error;
      return;
    }
    final result = apiResult.data;
    if (result != null) {
      _dataState = StageDataState.loaded;
      flow._processStageSubmitResult(result);
    }
  }

  void showStageErrorViewerDialog(BuildContext context) {
    // TODO:
  }

  Future<void> query() async {
    // TODO:
  }
}
