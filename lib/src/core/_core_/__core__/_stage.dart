part of '../core.dart';

/// Represents a distinct milestone or wizard step inside a [Prozess].
///
/// Lifecycle:
/// [StageDataStateNone] (unreached) -> [StageDataStatePending] (entering)
/// -> (resolves INIT_DATA) -> [StageDataStateLoadedFresh]
/// -> (submission) -> [StageDataStateSubmissionAttempted]
abstract class Stage<
    STAGE_ENUM extends StageEnum, //
    INIT_DATA extends StageInitData,
    RESULT_DATA extends StageResultData,
    PROZESS_CONTEXT_DATA extends ProzessContextData,
    FORM_INPUT extends FormInput,
    FORM_OUTPUT extends FormOutput> extends WorkNode<
    INIT_DATA, //
    RESULT_DATA,
    FORM_INPUT,
    FORM_OUTPUT> implements FormHost, ClassDefViewable {
  @override
  Map<String, Type> getGenericsInfoMap() {
    return {
      "STAGE_ENUM": STAGE_ENUM,
      "INIT_DATA": INIT_DATA,
      "RESULT_DATA": RESULT_DATA,
      "PROZESS_CONTEXT_DATA": PROZESS_CONTEXT_DATA,
      "FORM_INPUT": FORM_INPUT,
      "FORM_OUTPUT": FORM_OUTPUT,
    };
  }

  final STAGE_ENUM stageId;

  final StageConfig config;

  final StageEffectiveConfig effectiveConfig;

  late final debug = _StageDebugInfo(stage: this);

  late final Prozess<STAGE_ENUM, ProzessInitData, PROZESS_CONTEXT_DATA> prozess;

  late final ui = _StageUiComponents(stage: this);

  @override
  Activity get module => prozess.module;

  @override
  Activity get activity => prozess.activity;

  StageRouteStatus _stageRouteStatus = StageRouteStatus.unreached;

  void _setStageRouteStatusToActive() {
    _stageRouteStatus = StageRouteStatus.active;
  }

  void _setStageRouteStatusToBypassed() {
    _stageRouteStatus = StageRouteStatus.bypassed;
  }

  StageRouteStatus get stageRouteStatus => _stageRouteStatus;

  bool get isInActiveRoute => _stageRouteStatus == StageRouteStatus.active;

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

  bool get isSubmitted {
    return _dataState.isSubmissionAttemptedSuccess;
  }

  bool get isFrontierStage {
    return prozess._isFrontierStage(this);
  }

  bool get isViewingStage {
    return prozess._isViewingStage(this);
  }

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
    required XProzess<STAGE_ENUM, ProzessInitData, PROZESS_CONTEXT_DATA>
        xProzess,
    required XStageFormModel<STAGE_ENUM, INIT_DATA, RESULT_DATA,
            PROZESS_CONTEXT_DATA, FORM_INPUT, FORM_OUTPUT>?
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

  void _bindToProzess(
      Prozess<STAGE_ENUM, ProzessInitData, PROZESS_CONTEXT_DATA>
          parentProzess) {
    prozess = parentProzess;
  }

  @override
  void _refreshControlBars() {
    ui.refreshControlBars();
  }

  // ===========================================================================

  void _resetStageStateInternal() {
    _dataState = const StageDataStateNone();
     _clearData();
    _stageRouteStatus = StageRouteStatus.unreached;
    formModel?._clearDataWithDataState(
      formDataState: const FormDataStateNone(),
    );
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
    required FORM_OUTPUT? formData,
  });

  // ***************************************************************************
  // ***************************************************************************

  Future<StageSubmitResult<INIT_DATA, RESULT_DATA>>
      _submitAfterPrecheckSuccessful() async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "_submitAfterPrecheckSuccessful",
      parameters: {},
      isLibMethod: true,
    );

    // executionTrace.addNonControllableCall(
    //   codeId: "#120000",
    //   caller: this,
    //   methodName: "checkBeforeSubmit",
    //   suffixShortDesc: "",
    // );
    // Actionable<StageSubmitPrecheck> actionable =
    //     prozess.__checkBeforeSubmitStage(
    //   checkBusy: true,
    //   checkTargetFormValidate: true,
    //   targetStage: this,
    // );
    //
    // if (!actionable.yes) {
    //   _addErrorLogActionable(
    //     executionTrace: executionTrace,
    //     traceStepCodeId: "#120100",
    //     prefixShortDesc: 'checkBeforeSubmit()',
    //     module: module,
    //     actionableFalse: actionable,
    //     showErrSnackBar: true,
    //     tipDocument: null,
    //   );
    //   return StageSubmitExecutionResult(precheck: actionable.errCode);
    // }

    final XActivity xActivity = _XActivityStageSubmit(stage: this);
    final xStage = xActivity.findXStageByName(name) as XStage<STAGE_ENUM,
        INIT_DATA, RESULT_DATA, PROZESS_CONTEXT_DATA, FORM_INPUT, FORM_OUTPUT>;

    final StageSubmitIntent<STAGE_ENUM, INIT_DATA, RESULT_DATA,
            PROZESS_CONTEXT_DATA> executionIntent =
        xStage._createAndSetStageIntentSubmit();

    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xActivity);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    return executionIntent.result;
  }

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
    required StageRestartIntent<
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
          "${debugObjHtml(this)} -> Begin ${executionUnitType.asDebugExecutionUnit()} (Stage Load InitData)",
    );

    final executionResult = executionIntent.resultWrapper._setResult(
      StageRestartResult<
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
          "sharedContext": prozess._prozessContextData,
        },
      );
      debug._performLoadInitDataCount++;

      final ApiResult<INIT_DATA> result = await performLoadInitData(
          sharedContext: prozess._prozessContextData!);
      result.throwIfError();

      _initData = result.data;
      _dataState = const StageDataStateLoadedFresh();

      executionTrace.addInfo(
        codeId: "#092140",
        shortDesc:
            "${debugObjHtml(this)} -> Successfully resolved Stage INIT_DATA: ${debugObjHtml(_initData)}.",
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
    required XStage<STAGE_ENUM, INIT_DATA, RESULT_DATA, PROZESS_CONTEXT_DATA,
            FORM_INPUT, FORM_OUTPUT>
        thisXStage,
    required StageSubmitIntent<STAGE_ENUM, INIT_DATA, RESULT_DATA,
            PROZESS_CONTEXT_DATA>
        executionIntent,
  }) async {
    __assertThisXStage(thisXStage);
    thisXStage._createAndSetStageIntentDone(
      lastIntentInfo: "Submit",
    );

    executionTrace.addInfo(
      codeId: "#121100",
      shortDesc:
          "${debugObjHtml(this)} -> Begin ${executionUnitType.asDebugExecutionUnit()} (Submit)",
    );

    final executionResult = executionIntent.resultWrapper._setResult(
      StageSubmitResult<INIT_DATA, RESULT_DATA>(precheck: null),
      objectCaller: this,
      methodName: '_unitSubmit',
    );

    FORM_OUTPUT? formOutput;
    try {
      formOutput = formModel?._getFormOutput();
    } catch (e, stackTrace) {
      formOutput = null;
      final ErrorInfo errorInfo = _handleError(
        module: module,
        methodName: "convertToFormOutput",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      executionResult._setErrorInfo(errorInfo: errorInfo);
      //
      StageErrorInfo stageErrorInfo = StageErrorInfo(
        stageErrorMethod: StageErrorMethod.convertToFormOutput,
        error: e,
        errorStackTrace: stackTrace,
      );
      _dataState = StageDataStateSubmissionAttemptedFailed(
        submissionErrorInfo: stageErrorInfo,
      );
      return;
    }
    RESULT_DATA? stageDataResult;
    try {
      ApiResult<RESULT_DATA> result = await performSubmit(
        initData: initData!,
        sharedContext: prozess._prozessContextData!,
        formData: formOutput,
      );
      // Throw Error!
      result.throwIfError();
      stageDataResult = result.data;

      if (stageDataResult == null) {
        if (RESULT_DATA == EmptyStageResultData) {
          stageDataResult = EmptyStageResultData() as RESULT_DATA;
        } else {
          throw AppError(
            errorMessage:
                '${getClassName(this)}.performSubmit() return null (${getClassName(RESULT_DATA)}).',
          );
        }
      }
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        module: module,
        methodName: "performSubmit",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      executionResult._setErrorInfo(errorInfo: errorInfo);
      //
      StageErrorInfo stageErrorInfo = StageErrorInfo(
        stageErrorMethod: StageErrorMethod.performSubmit,
        error: e,
        errorStackTrace: stackTrace,
      );
      _dataState = StageDataStateSubmissionAttemptedFailed(
        submissionErrorInfo: stageErrorInfo,
      );
      return;
    }
    //
    _dataState = StageDataStateSubmissionAttemptedSuccess();
    _submitResultData = stageDataResult;

    thisXStage.xProzess._createAndSetProzessIntentDetermineNextStage(
      // TODO: Risk!
      prozessInitData: thisXStage.xProzess.prozess._prozessInitData!,
    );
  }

  // ===========================================================================
  //
  // ===========================================================================

  /// Triggers resolution of stage baseline data through the execution queue.
  Future<
      StageRestartResult<
          STAGE_ENUM, //
          INIT_DATA,
          RESULT_DATA,
          PROZESS_CONTEXT_DATA>> _restartAfterPrecheckSuccessful() async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "_restartAfterPrecheckSuccessful",
      parameters: null,
      isLibMethod: true,
    );

    final XActivity xActivity = _XActivityStageRestart(stage: this);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xActivity);
    await FlutterArtist.executor._executeExecutionUnitQueue();

    final thisXStage = xActivity.findXStageByName(name) as XStage<
        STAGE_ENUM, //
        INIT_DATA,
        RESULT_DATA,
        PROZESS_CONTEXT_DATA,
        FORM_INPUT,
        FORM_OUTPUT>;
    return thisXStage.stageRestartResult;
  }

  // ===========================================================================
  // PUBLIC CONTROLS
  // ===========================================================================

  @override
  bool isStateReadyForForm() {
    if (dataState.isNone || dataState.isPending || dataState.isStale) {
      return false;
    } else if (dataState.isFresh ||
        dataState.isSubmissionAttemptedSuccess ||
        dataState.isSubmissionAttemptedFailed) {
      return true;
    } else {
      // Never run.
      throw UnimplementedError("Stage: Never run: $dataState");
    }
  }

  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<StageFormEnablePrecheck> checkFormEnable({
    bool checkAllow = true,
  }) {
    final int? targetStageOrder = stageId.stageOrder;
    final int? viewingStageOrder = prozess.viewingStage?.stageId.stageOrder;

    return StageFormEnablePrecheckUtils.checkFormEnable(
      checkBusy: true,
      isBusy: FlutterArtist.executor.isBusy,
      targetStageOrder: targetStageOrder,
      viewingStageOrder: viewingStageOrder,
      hasForm: hasForm,
      targetStageDataState: _dataState,
      targetFormDataState: formModel?.dataState,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckMethod()
  @override
  Actionable<ShowFormInfoPrecheck> checkBeforeShowFormInfo() {
    return __checkBeforeShowFormInfo(formModel: formModel);
  }

  @override
  Future<Actionable<ShowFormInfoPrecheck>>
      showDebugFormModelInspectorDialog() async {
    final actionable = checkBeforeShowFormInfo();
    if (!actionable.yes) {
      return actionable;
    }
    final BuildContext context = FlutterArtistCore.context;
    await DebugFormModelInspectorDialog.show(
      context: context,
      locationInfo: getClassNameWithoutGenerics(this),
      formModel: formModel!,
    );
    return actionable;
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
