part of '../core.dart';

/// Represents a distinct milestone or wizard step inside a [Prozess].
///
/// Lifecycle:
/// [StageDataStateNone] (unreached) -> [StageDataStatePending] (entering)
/// -> (resolves INIT_DATA) -> [StageDataStateLoadedFresh]
/// -> (submission) -> [StageDataStateSubmissionAttempted]
abstract class Stage<
    STAGE_ENUM extends Enum,
    INIT_DATA extends StageInitData,
    RESULT_DATA extends StageResultData,
    PROZESS_CONTEXT_DATA extends ProzessContextData,
    CREATION_PRESET extends CreationPreset,
    FORM_INPUT extends FormInput> extends _Core {
  final STAGE_ENUM stageId;
  final String name;
  final String? description;
  final StageConfig config;
  final StageEffectiveConfig effectiveConfig;

  late final debug = _StageDebugInfo(stage: this);

  late final Prozess<STAGE_ENUM, PROZESS_CONTEXT_DATA> prozess;
  late final ui = _StageUiComponents(stage: this);

  Activity get activity => prozess.activity;
  PROZESS_CONTEXT_DATA get sharedContext => prozess.contextData;

  StageFormModel<
      STAGE_ENUM, //
      INIT_DATA,
      RESULT_DATA,
      PROZESS_CONTEXT_DATA,
      CREATION_PRESET,
      FORM_INPUT,
      AdditionalFormRelatedData>? formModel;

  // ===========================================================================
  // EMBEDDED STAGE STATE STORAGE
  // ===========================================================================

  StageDataState _dataState = const StageDataStateNone();
  StageDataState get dataState => _dataState;

  INIT_DATA? _initData;
  INIT_DATA? get initData => _initData;

  RESULT_DATA? _lastResultData;
  RESULT_DATA? get lastResultData => _lastResultData;

  bool __isLoadingInitData = false;
  bool get isLoadingInitData => __isLoadingInitData;

  bool __isSubmitting = false;
  bool get isSubmitting => __isSubmitting;

  bool get hasForm => formModel != null;
  bool get hasError => _dataState.hasError;
  StageErrorInfo? get errorInfo => _dataState.errorInfo;

  // ===========================================================================
  // Constructor
  // ===========================================================================

  Stage({
    required this.stageId,
    required this.name,
    this.description,
    this.config = const StageConfig(),
    required this.formModel,
  }) : effectiveConfig = StageEffectiveConfig.fromConfig(config) {
    formModel?._bindToStage(this);
  }

  // ===========================================================================

  XStage _createXStage(
      {required XProzess<STAGE_ENUM, PROZESS_CONTEXT_DATA> xProzess}) {
    return XStage<STAGE_ENUM, INIT_DATA, RESULT_DATA, PROZESS_CONTEXT_DATA,
        CREATION_PRESET, FORM_INPUT>._(
      stage: this,
      xProzess: xProzess,
    );
  }

  // ===========================================================================

  void _bindToProzess(Prozess<STAGE_ENUM, dynamic> parentProzess) {
    prozess = parentProzess as Prozess<STAGE_ENUM, PROZESS_CONTEXT_DATA>;
  }

  // ===========================================================================
  // GENERICS TYPES:
  // ===========================================================================

  Type getStageEnumType() => STAGE_ENUM;
  Type getInitDataType() => INIT_DATA;
  Type getResultDataType() => RESULT_DATA;
  Type getProzessContextDataType() => PROZESS_CONTEXT_DATA;
  Type getCreationPresetType() => CREATION_PRESET;
  Type getFormInputType() => FORM_INPUT;

  // ===========================================================================
  // ABSTRACT CONTRACTS
  // ===========================================================================

  /// Synchronously or asynchronously resolves baseline [INIT_DATA] for this Stage
  /// from the shared [PROZESS_CONTEXT_DATA] and predecessor states.
  @_AbstractMethodAnnotation()
  Future<ApiResult<INIT_DATA>> performLoadInitData({
    required PROZESS_CONTEXT_DATA sharedContext,
  });

  /// Submits the stage form inputs, commits data, and yields [RESULT_DATA].
  @_AbstractMethodAnnotation()
  Future<ApiResult<RESULT_DATA>> performSubmit({
    required INIT_DATA initData,
    required PROZESS_CONTEXT_DATA sharedContext,
    required Map<String, dynamic> formStageData,
  });

  // ===========================================================================
  // EXECUTION UNIT: _unitLoadInitData
  // ===========================================================================

  /// Internal ExecutionUnit method handling INIT_DATA resolution when stage is activated.
  ///
  /// Invoked by [_StageLoadInitDataExcutionUnit].
  @_ExecutionUnitMethodAnnotation()
  Future<void> _unitLoadInitData({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XStage thisXStage,
    required StageLoadInitDataIntent<
            STAGE_ENUM, //
            INIT_DATA,
            RESULT_DATA,
            PROZESS_CONTEXT_DATA>
        executionIntent,
  }) async {
    __assertThisXStage(thisXStage);

    executionTrace.addInfo(
      codeId: "#92100",
      shortDesc:
          "${debugObjHtml(this)} -> Begin ${executionUnitType.asDebugExecutionUnit()} (Stage Load InitData)",
    );

    final executionResult = executionIntent.resultWrapper._setResult(
      StageLoadInitDataResult<
          STAGE_ENUM, //
          INIT_DATA,
          RESULT_DATA,
          PROZESS_CONTEXT_DATA>(precheck: null),
      objectCaller: this,
      methodName: '_unitLoadInitData',
    );

    StageErrorInfo? stageErrorInfo;
    try {
      __refreshLoadingInitDataState(isLoading: true);

      executionTrace.addControllableCall(
        codeId: "#92120",
        caller: this,
        methodName: "performLoadInitData",
        suffixShortDesc: "",
        parameters: {
          "sharedContext": sharedContext,
        },
      );
      debug._performLoadInitDataCount++;

      final ApiResult<INIT_DATA> result =
          await performLoadInitData(sharedContext: sharedContext);
      result.throwIfError();

      _initData = result.data;
      _dataState = const StageDataStateLoadedFresh();

      executionTrace.addInfo(
        codeId: "#92140",
        shortDesc:
            "${debugObjHtml(this)} -> Successfully resolved Stage INIT_DATA: ${debugObjHtml(_initData)}.",
      );
    } catch (e, stackTrace) {
      stageErrorInfo = StageErrorInfo(
        stageErrorMethod: StageErrorMethod.performLoadInitData,
        error: e,
        errorStackTrace: stackTrace,
      );

      final ErrorInfo errorInfo = _handleError(
        shelf: null,
        methodName: "performLoadInitData",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );

      executionResult._setErrorInfo(errorInfo: errorInfo);

      if (_initData != null) {
        _dataState = StageDataStateLoadedStale(staleErrorInfo: stageErrorInfo);
      } else {
        _dataState = StageDataStatePending.failed(errorInfo: stageErrorInfo);
      }

      executionTrace.addInfo(
        codeId: "#92160",
        shortDesc:
            "The ${debugObjHtml(this)}.performLoadInitData() method encountered an error!",
        errorInfo: errorInfo,
      );
    } finally {
      __refreshLoadingInitDataState(isLoading: false);
    }
  }

  // ===========================================================================
  // EXECUTION UNIT: _unitSubmit
  // ===========================================================================

  Future<void> _unitSubmit({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XStage<Enum, StageInitData, StageResultData, ProzessContextData,
            CreationPreset, FormInput>
        thisXStage,
    required StageSubmitExecutionIntent<Enum, StageInitData, StageResultData,
            ProzessContextData>
        executionIntent,
  }) async {
    // Handled in subsequent phase
  }

  // ===========================================================================
  // PUBLIC CONTROLS
  // ===========================================================================

  /// Triggers resolution of stage baseline data through the execution queue.
  Future<
      StageLoadInitDataResult<
          STAGE_ENUM,
          INIT_DATA,
          RESULT_DATA, //
          PROZESS_CONTEXT_DATA>> loadInitData() async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "loadInitData",
      parameters: null,
      isLibMethod: true,
    );

    final XActivity xActivity = _XActivityStageLoadInitData(stage: this);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xActivity);
    await FlutterArtist.executor._executeExecutionUnitQueue();

    final thisXStage = xActivity.findXStageByName(name) as XStage<
        STAGE_ENUM, //
        INIT_DATA,
        RESULT_DATA,
        PROZESS_CONTEXT_DATA,
        CREATION_PRESET,
        FORM_INPUT>;
    return thisXStage.loadInitDataResult;
  }

  // bool isPendingOrStale({required bool requiresVisible}) {
  //   final bool visible = ui.hasVisibleViews();
  //   if (requiresVisible && !visible) {
  //     return false;
  //   }
  //   return dataState.isPending || dataState.isStale;
  // }

  /// Clears stage data and resets back to inactive state.
  void clear() {
    _initData = null;
    _lastResultData = null;
    _dataState = const StageDataStateNone();
  }

  void __refreshLoadingInitDataState({required bool isLoading}) {
    try {
      __isLoadingInitData = isLoading;
      ui.refreshControlBars();
    } catch (_) {}
  }

  void showStageErrorViewerDialog(BuildContext context) {
    if (errorInfo != null) {
      ErrorViewerDialog.show(
        context: context,
        errorInfo: errorInfo!.toErrorInfo(),
      );
    }
  }



  void _broadcastStageHidden() {
    // TODO:...
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void __assertThisXStage(XStage thisXStage) {
    if (thisXStage.stage != this || thisXStage.name != name) {
      throw "Error Assert stage: ${thisXStage.stage} - $this";
    }
  }
}
