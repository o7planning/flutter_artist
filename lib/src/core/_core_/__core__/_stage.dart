part of '../core.dart';

/// Represents a distinct milestone or wizard step inside a [Prozess].
///
/// Lifecycle:
/// [StageDataStateNone] (unreached) -> [StageDataStatePending] (entering)
/// -> (resolves INIT_DATA) -> [StageDataStateLoadedFresh]
/// -> (submission) -> [StageDataStateSubmissionAttempted]
abstract class Stage<
STAGE_ENUM extends Enum, //
INIT_DATA extends StageInitData,
RESULT_DATA extends StageResultData,
PROZESS_CONTEXT_DATA extends ProzessContextData,
FORM_INPUT extends FormInput,
FORM_OUTPUT extends FormOutput> extends WorkNode<
    INIT_DATA, //
    RESULT_DATA,
    FORM_INPUT,
    FORM_OUTPUT>
    implements FormHost {
  final STAGE_ENUM stageId;

  final StageConfig config;
  final StageEffectiveConfig effectiveConfig;

  late final debug = _StageDebugInfo(stage: this);

  late final Prozess<STAGE_ENUM, PROZESS_CONTEXT_DATA> prozess;

  late final ui = _StageUiComponents(stage: this);

  @override
  Activity get module => prozess.module;

  @override
  Activity get activity => prozess.activity;

  PROZESS_CONTEXT_DATA get sharedContext => prozess.contextData;

  @override
  StageFormModel<
      STAGE_ENUM, //
      INIT_DATA,
      RESULT_DATA,
      PROZESS_CONTEXT_DATA,
      FORM_INPUT,
      FORM_OUTPUT,
      AdditionalFormRelatedData>? formModel;

  // ===========================================================================
  // EMBEDDED STAGE STATE STORAGE
  // ===========================================================================

  StageDataState _dataState = const StageDataStateNone();

  StageDataState get dataState => _dataState;

  @override
  bool get hasForm => formModel != null;

  @override
  bool get hasError => _dataState.hasError;

  StageErrorInfo? get errorInfo => _dataState.errorInfo;

  // ===========================================================================
  // Constructor
  // ===========================================================================

  Stage({
    required this.stageId,
    required super.name,
    super.description,
    this.config = const StageConfig(),
    required this.formModel,
  }) : effectiveConfig = StageEffectiveConfig.fromConfig(config) {
    formModel?._bindToStage(this);
  }

  // ===========================================================================

  XStage _createXStage({
    required XProzess<STAGE_ENUM, PROZESS_CONTEXT_DATA> xProzess,
    required XStageFormModel<STAGE_ENUM,
        INIT_DATA,
        RESULT_DATA,
        PROZESS_CONTEXT_DATA,
        FORM_INPUT,
        FORM_OUTPUT>?
    xStageFormModel,
  }) {
    return XStage<
        STAGE_ENUM, //
        INIT_DATA,
        RESULT_DATA,
        PROZESS_CONTEXT_DATA,
        FORM_INPUT,
        FORM_OUTPUT>._(
      stage: this,
      xProzess: xProzess,
      xStageFormModel: xStageFormModel,
    );
  }

  // ===========================================================================

  void _bindToProzess(Prozess<STAGE_ENUM, dynamic> parentProzess) {
    prozess = parentProzess as Prozess<STAGE_ENUM, PROZESS_CONTEXT_DATA>;
  }

  @override
  void _refreshControlBars() {
    ui.refreshControlBars();
  }

  // ===========================================================================
  // GENERICS TYPES:
  // ===========================================================================

  Type getStageEnumType() => STAGE_ENUM;

  Type getProzessContextDataType() => PROZESS_CONTEXT_DATA;

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
    thisXStage._createAndSetStageIntentDone(
      lastIntentInfo: "Load Init Data",
    );

    executionTrace.addInfo(
      codeId: "#092100",
      shortDesc:
      "${debugObjHtml(this)} -> Begin ${executionUnitType
          .asDebugExecutionUnit()} (Stage Load InitData)",
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
        codeId: "#092120",
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
        codeId: "#092140",
        shortDesc:
        "${debugObjHtml(
            this)} -> Successfully resolved Stage INIT_DATA: ${debugObjHtml(
            _initData)}.",
      );

      // Coordinate StageFormModel data state transition
      if (formModel != null) {
        final newFormDataState =
        BlockFormDataStateUtils.calculateNewLazyDataState(
          currentFormDataState: formModel!.dataState,
          hasCurrentItem: _initData != null,
          currentItemChanged: true,
        );
        formModel!._formModelStructure._setFormDataState(
          formDataState: newFormDataState,
          error: null,
        );
      }
    } catch (e, stackTrace) {
      stageErrorInfo = StageErrorInfo(
        stageErrorMethod: StageErrorMethod.performLoadInitData,
        error: e,
        errorStackTrace: stackTrace,
      );

      final ErrorInfo errorInfo = _handleError(
        module: null,
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
        codeId: "#092160",
        shortDesc:
        "The ${debugObjHtml(
            this)}.performLoadInitData() method encountered an error!",
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
    required XStage<Enum,
        StageInitData,
        StageResultData,
        ProzessContextData,
        FormInput,
        FormOutput>
    thisXStage,
    required StageSubmitIntent<Enum,
        StageInitData,
        StageResultData,
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
        FORM_INPUT,
        FORM_OUTPUT>;
    return thisXStage.loadInitDataResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  bool isStateReadyForForm() {
    if (dataState.isPending || dataState.isStale) {
      return false;
    } else if (dataState.isFresh ||
        dataState.isSubmissionAttemptedSuccess ||
        dataState.isSubmissionAttemptedFailed) {
      return true;
    } else {
      // Never run.
      throw UnimplementedError("Stage: Never run");
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<StageFormEnablePrecheck> checkFormEnable({
    bool checkAllow = true,
  }) {
    if (formModel == null) {
      return Actionable<StageFormEnablePrecheck>.no(
        errCode: StageFormEnablePrecheck.noForm,
      );
    }
    if (!isStateReadyForForm()) {
      return Actionable<StageFormEnablePrecheck>.no(
        errCode: StageFormEnablePrecheck.noForm,
      );
    }
    final FormDataState formDataState = formModel!.dataState;

    if (formDataState.isNone) {
      return Actionable<StageFormEnablePrecheck>.no(
        errCode: StageFormEnablePrecheck.formInNoneState,
      );
    } else if (formDataState.isPending) {
      return Actionable<StageFormEnablePrecheck>.no(
        errCode: StageFormEnablePrecheck.formInPendingState,
      );
    } else if (formDataState.isFatalError) {
      return Actionable<StageFormEnablePrecheck>.no(
        errCode: StageFormEnablePrecheck.formInFatalErrorState,
      );
    } else if (formDataState.isStale) {
      return Actionable<StageFormEnablePrecheck>.no(
        errCode: StageFormEnablePrecheck.formInStaleState,
      );
    }
    return Actionable<StageFormEnablePrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

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
