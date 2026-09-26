part of '../core.dart';

abstract class Stage<
    STAGE_ENUM extends Enum,
    INIT_DATA extends StageInitData,
    RESULT_DATA extends StageResultData,
    FLOW_CONTEXT_DATA extends FlowContextData,
    CREATION_PRESET extends CreationPreset,
    FORM_INPUT extends FormInput> extends _Core {
  final STAGE_ENUM stageId;
  final String name;
  final StageConfig config;
  final StageEffectiveConfig effectiveConfig;

  final StageFormModel<STAGE_ENUM,  INIT_DATA, RESULT_DATA, FLOW_CONTEXT_DATA,
      CREATION_PRESET, FORM_INPUT, AdditionalFormRelatedData>? formModel;

  late final Flow<STAGE_ENUM, FLOW_CONTEXT_DATA> flow;

  StageDataState _dataState = StageDataStateNone();
  StageDataState get dataState => _dataState;

  Activity get activity => flow.activity;
  FLOW_CONTEXT_DATA get sharedContext => flow.contextData;

  INIT_DATA? _initData;
  INIT_DATA? get initData => _initData;

  RESULT_DATA? _lastResultData;
  RESULT_DATA? get lastResultData => _lastResultData;

  late final ui = _StageUiComponents(stage: this);

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

  bool get hasForm => formModel != null;
  bool get hasError => _dataState.hasError;

  // ===========================================================================
  // ABSTRACT METHODS
  // ===========================================================================

  /// Synchronously or asynchronously resolves the baseline [INIT_DATA] for this Stage
  /// by extracting and projecting relevant data from the shared [FLOW_CONTEXT_DATA].
  @_AbstractMethodAnnotation()
  FutureOr<INIT_DATA> resolveStageInitData({
    required FLOW_CONTEXT_DATA sharedContext,
  });

  /// Submits the stage data, persists progress, and yields [RESULT_DATA] along with [nextStage].
  @_AbstractMethodAnnotation()
  Future<ApiResult<StageExecutionResult<STAGE_ENUM, RESULT_DATA>>>
      performStageSubmit({
    required Map<String, dynamic> formStageData,
    required INIT_DATA initData,
    required FLOW_CONTEXT_DATA sharedContext,
  });

  /// Builds synchronous in-memory presets for this stage form.
  @_AbstractMethodAnnotation()
  CREATION_PRESET buildCreationPreset({
    required FLOW_CONTEXT_DATA sharedContext,
  });

  // ===========================================================================
  // STAGE LIFECYCLE & DISPATCH
  // ===========================================================================

  /// Prepares the stage when entered: loads [initData] and initializes the form.
  Future<void> prepareStage() async {
    _dataState = const StageDataStatePending();
    try {
      _initData = await resolveStageInitData(sharedContext: sharedContext);
      if (formModel != null) {
        await formModel!._initStageForm(
          initData: _initData!,
          creationPreset: buildCreationPreset(sharedContext: sharedContext),
        );
      }
      _dataState = const StageDataStateLoadedFresh();
      ui.refreshAllViews();
    } catch (e, stackTrace) {
      final errorInfo = _handleError(
        shelf: null,
        methodName: "prepareStage",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      _dataState = StageDataStateLoadedStale(errorInfo: errorInfo);
    }
  }

  /// Internal handler receiving submission outcome and forwarding to parent Flow.
  Future<void> _processStageSubmitResult(
    ApiResult<StageExecutionResult<STAGE_ENUM, RESULT_DATA>> apiResult,
  ) async {
    apiResult.throwIfError();
    final result = apiResult.data;
    if (result != null) {
      _lastResultData = result.resultData;
      _dataState = const StageDataStateLoadedFresh();

      // Merge outcome into parent workflow
      flow._processStageSubmitResult(result);
    }
  }

  void showStageErrorViewerDialog(BuildContext context) {
    if (_dataState.errorInfo != null) {
      ErrorViewerDialog.show(
        context: context,
        errorInfo: _dataState.errorInfo!,
      );
    }
  }
}
