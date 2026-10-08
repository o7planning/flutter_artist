part of '../core.dart';

abstract class Prozess<
        STAGE_ENUM extends StageEnum, //
        PROZESS_INIT_DATA extends ProzessInitData,
        PROZESS_CONTEXT_DATA extends ProzessContextData> extends _Core
    implements ClassDefViewable {
  @override
  Map<String, Type> getGenericsInfoMap() {
    return {
      "STAGE_ENUM": STAGE_ENUM,
      "PROZESS_INIT_DATA": PROZESS_INIT_DATA,
      "PROZESS_CONTEXT_DATA": PROZESS_CONTEXT_DATA,
    };
  }

  final String name;

  STAGE_ENUM? _viewingStageEnum;

  STAGE_ENUM? get viewingStageEnum => _viewingStageEnum;

  Stage? get viewingStage =>
      _viewingStageEnum == null ? null : __stageMap[_viewingStageEnum];

  ProzessDataState _dataState = ProzessDataStatePending();

  ProzessDataState get dataState => _dataState;

  PROZESS_CONTEXT_DATA? _prozessContextData;

  late final debug = _ProzessDebugInfo(prozess: this);

  final Map<STAGE_ENUM, Stage> __stageMap = {};

  final List<Stage> _orderedStages = [];

  List<Stage> get orderedStages => List.unmodifiable(_orderedStages);

  /// Returns an unmodifiable list of active stages that belong to the executed workflow path
  /// (where [StageRouteStatus] is [StageRouteStatus.active]), sorted by their canonical stage order.
  List<Stage> get orderedActiveStages {
    return List.unmodifiable(
      _orderedStages
          .where((stage) => stage.stageRouteStatus == StageRouteStatus.active),
    );
  }

  List<STAGE_ENUM> get orderedActiveStageEnums {
    return List.unmodifiable(
        orderedActiveStages.map((s) => s.stageId).toList());
  }

  late final Activity activity;

  Activity get module => activity;

  late final ui = _ProzessUiComponents(prozess: this);

  String get title => "Prozess";

  /// Total number of stage enum values defined for this Prozess.
  /// Must be implemented by subclasses to ensure all stage enum members are correctly mapped.
  int get totalStageEnumCount;

  PROZESS_INIT_DATA? _prozessInitData;

  bool _isStageReexecutionAllowed = false;

  Prozess({required this.name}) {
    __initializeProzess();
  }

  get hasError => false; // TODO.

  // ***************************************************************************

  XProzess<STAGE_ENUM, PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA>
      _createXProzess({
    required XActivity xActivity,
  }) {
    return XProzess<STAGE_ENUM, PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA>._(
      prozess: this,
      xActivity: xActivity,
    );
  }

  // ***************************************************************************

  void __initializeProzess() {
    final ProzessStructure<STAGE_ENUM, PROZESS_CONTEXT_DATA> flowStructure =
        defineProzessStructure();

    final stages = flowStructure.stages;

    // ===========================================================================
    // PHASE 1: VALIDATE
    // ===========================================================================

    if (stages.isEmpty) {
      throw AppFatalErrorUtils.___registerError(
        "Prozess '${getClassName(this)}' must have at least one Stage.",
      );
    }

    // Validate the total number of configured stages against totalStageEnumCount.
    final int expectedCount = totalStageEnumCount;
    if (stages.length != expectedCount) {
      throw AppFatalErrorUtils.___registerError(
        "Invalid number of stages in Prozess '${getClassName(this)}': "
        "expected $expectedCount, but found ${stages.length}.",
      );
    }

    final stageIds = <STAGE_ENUM>{};
    final stageOrders = <int>{};
    final stageCodes = <String>{};

    for (final stage in stages) {
      final stageEnum = stage.stageId as STAGE_ENUM;

      // Validate duplicate Stage IDs.
      if (!stageIds.add(stageEnum)) {
        throw AppFatalErrorUtils.___registerError(
          "Duplicate Stage Enum '${stage.stageId}' in Prozess '${getClassName(this)}'.",
        );
      }
      // Validate duplicate Stage Orders.
      if (!stageOrders.add(stageEnum.stageOrder)) {
        throw AppFatalErrorUtils.___registerError(
          "Duplicate Stage Order '${stageEnum.stageOrder}' in StageEnum '${getClassName(stageEnum)}'.",
        );
      }
      // Validate duplicate Stage Codes.
      if (!stageCodes.add(stageEnum.stageCode)) {
        throw AppFatalErrorUtils.___registerError(
          "Duplicate Stage Code '${stageEnum.stageCode}' in StageEnum '${getClassName(stageEnum)}'.",
        );
      }
    }

    // ===========================================================================
    // PHASE 2: SORT
    // ===========================================================================

    final orderedStages = [...stages]..sort((a, b) {
        final aOrder = (a.stageId as STAGE_ENUM).stageOrder;
        final bOrder = (b.stageId as STAGE_ENUM).stageOrder;

        return aOrder.compareTo(bOrder);
      });

    // ===========================================================================
    // PHASE 3: REGISTER AND BIND
    // ===========================================================================
    final stageMap = <STAGE_ENUM, Stage>{};
    for (final stage in orderedStages) {
      final stageEnum = stage.stageId as STAGE_ENUM;

      stageMap[stageEnum] = stage;
      stage._bindToProzess(this);
    }
    __stageMap
      ..clear()
      ..addAll(stageMap);
    _orderedStages
      ..clear()
      ..addAll(orderedStages);

    // ===========================================================================
    // PHASE 4: INITIALIZE CURRENT STAGE
    // ===========================================================================
    //
    // _viewingStageEnum = orderedStages.first.stageId as STAGE_ENUM;
  }

  void _bindToActivity(Activity parentActivity) {
    activity = parentActivity;
  }

  // ***************************************************************************
  // ***************************************************************************

  Type getStageEnumType() {
    return STAGE_ENUM;
  }

  Type getProzessInitDataType() {
    return PROZESS_INIT_DATA;
  }

  Type getProzessContextDataType() {
    return PROZESS_CONTEXT_DATA;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  ProzessStructure<STAGE_ENUM, PROZESS_CONTEXT_DATA> defineProzessStructure();

  @_AbstractMethodAnnotation()
  Future<ApiResult<PROZESS_INIT_DATA>> performLoadInitData();

  @_AbstractMethodAnnotation()
  STAGE_ENUM? determineNextStage({
    required List<STAGE_ENUM> orderedActiveStageEnums,
    required PROZESS_CONTEXT_DATA sharedContext,
    required PROZESS_INIT_DATA prozessInitData,
  });

  @_AbstractMethodAnnotation()
  PROZESS_CONTEXT_DATA createProzessContextData({
    required PROZESS_INIT_DATA prozessInitData,
  });

  @_AbstractMethodAnnotation()
  bool isStageReexecutionAllowed({required PROZESS_INIT_DATA prozessInitData});

  // ***************************************************************************
  // ***************************************************************************

  Stage? findStage(STAGE_ENUM stageId) {
    return __stageMap[stageId];
  }

  Stage? findFrontierStage() {
    print("\n\n\n\n findFrontierStage");
    print("orderedActiveStages: ${orderedActiveStages}");
    Stage? lastActiveStage = orderedActiveStages.lastOrNull;

    print("lastActiveStage: ${lastActiveStage}");
    if (lastActiveStage == null) {
      return null;
    }
    print("lastActiveStage.dataState: ${lastActiveStage.dataState}");
    if (!lastActiveStage.dataState.isSubmissionAttemptedSuccess) {
      return lastActiveStage;
    }
    return null;
  }

  bool _isFrontierStage(Stage stage) {
    Stage? frontierStage = findFrontierStage();
    return identical(frontierStage, stage);
  }

  bool _isViewingStage(Stage stage) {
    return identical(viewingStage, stage);
  }

  bool setViewingStageEnum(STAGE_ENUM stageEnum) {
    Stage stage = findStageByEnum(stageEnum);
    if (stage.isInActiveRoute) {
      _viewingStageEnum = stageEnum;
      return true;
    } else {
      return false;
    }
  }

  Stage findStageByEnum(StageEnum stageEnum) {
    return __stageMap[stageEnum]!;
  }

  Stage? findStageByCode({required String stageCode}) {
    for (Stage stage in _orderedStages) {
      if (stage.stageId.stageCode == stageCode) {
        return stage;
      }
    }
    return null;
  }

  StageEnum? findStageEnumByCode({required String stageCode}) {
    return findStageByCode(stageCode: stageCode)?.stageId;
  }

  // ***************************************************************************
  // ROUTING & NAVIGATION CONTROLS (StageRouteStatus Aware)
  // ***************************************************************************

  /// Navigates the prozess view pointer to the specified [stageId].
  ///
  /// Returns `false` if the target stage does not exist or is not eligible to become active.
  bool moveToStage(STAGE_ENUM stageId) {
    final Stage? targetStage = findStage(stageId);
    if (targetStage == null) {
      return false;
    }

    // Update route status for the target stage to active.
    targetStage._stageRouteStatus = StageRouteStatus.active;
    _viewingStageEnum = stageId;

    // Refresh UI representations to reflect the new viewing stage.
    _refreshProzessAfterChangeViewingStage();
    return true;
  }

  // ===========================================================================
  // NEXT & PREVIOUS STAGE NAVIGATION CONTROLS
  // ===========================================================================

  /// Evaluates whether the prozess can move forward to the next active stage in [orderedActiveStages].
  bool canMoveToNextStage() {
    if (_viewingStageEnum == null) {
      return false;
    }

    final Stage? currentStage = viewingStage;
    if (currentStage == null) {
      return false;
    }

    final List<Stage> activeStages = orderedActiveStages;
    final int currentIndex = activeStages.indexOf(currentStage);

    // Returns true if there is at least one active stage ahead in the sequence.
    return currentIndex >= 0 && currentIndex < activeStages.length - 1;
  }

  /// Evaluates whether the prozess can move backward to the previous active stage in [orderedActiveStages].
  bool canMoveToPreviousStage() {
    if (_viewingStageEnum == null) {
      return false;
    }

    final Stage? currentStage = viewingStage;
    if (currentStage == null) {
      return false;
    }

    final List<Stage> activeStages = orderedActiveStages;
    final int currentIndex = activeStages.indexOf(currentStage);

    // Returns true if there is at least one active stage behind in the sequence.
    return currentIndex > 0;
  }

  /// Moves the viewing stage pointer forward to the next active stage in [orderedActiveStages].
  ///
  /// Returns `true` if successful, or `false` if no subsequent active stage exists.
  bool moveToNextStage() {
    if (!canMoveToNextStage()) {
      return false;
    }

    final Stage? currentStage = viewingStage;
    if (currentStage == null) {
      return false;
    }

    final List<Stage> activeStages = orderedActiveStages;
    final int currentIndex = activeStages.indexOf(currentStage);

    if (currentIndex >= 0 && currentIndex < activeStages.length - 1) {
      final Stage nextActiveStage = activeStages[currentIndex + 1];
      _viewingStageEnum = nextActiveStage.stageId as STAGE_ENUM;

      // Refresh UI to display the next active stage view and form.
      _refreshProzessAfterChangeViewingStage();
      return true;
    }

    return false;
  }

  /// Moves the viewing stage pointer backward to the previous active stage in [orderedActiveStages].
  ///
  /// Returns `true` if successful, or `false` if no preceding active stage exists.
  bool moveToPreviousStage() {
    if (!canMoveToPreviousStage()) {
      return false;
    }

    final Stage? currentStage = viewingStage;
    if (currentStage == null) {
      return false;
    }

    final List<Stage> activeStages = orderedActiveStages;
    final int currentIndex = activeStages.indexOf(currentStage);

    if (currentIndex > 0) {
      final Stage prevActiveStage = activeStages[currentIndex - 1];
      _viewingStageEnum = prevActiveStage.stageId as STAGE_ENUM;

      // Refresh UI to display the previous active stage view and form.
      _refreshProzessAfterChangeViewingStage();
      return true;
    }

    return false;
  }

  // ***************************************************************************

  void _processStageSubmitResult(
      NextStageDeterminationOutcome<STAGE_ENUM, StageResultData> result) {
    if (result.isFinished) {
      _dataState = ProzessDataStateCompleted();
      return;
    }
    if (result.nextStageEnum != null) {
      moveToStage(result.nextStageEnum!);
    }
  }

  Future<StageLoadInitDataResult> loadViewingStageInitData() async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "loadViewingStageInitData",
      parameters: {},
      isLibMethod: true,
    );
    //
    executionTrace.addNonControllableCall(
      codeId: "#123000",
      caller: this,
      methodName: "checkBeforeViewingStageLoadInitData",
      suffixShortDesc: "",
    );
    final Actionable<StageLoadInitDataPrecheck> actionable =
        checkBeforeViewingStageLoadInitData();

    if (!actionable.yes) {
      _addErrorLogActionable(
        executionTrace: executionTrace,
        traceStepCodeId: "#123100",
        prefixShortDesc: 'checkBeforeViewingStageLoadInitData()',
        module: module,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return StageLoadInitDataResult(precheck: actionable.errCode);
    }
    return await viewingStage!._loadInitDataAfterPrecheckSuccessful();
  }

  Future<StageSubmitResult> submitViewingStage() async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "submitViewingStage",
      parameters: {},
      isLibMethod: true,
    );
    //
    executionTrace.addNonControllableCall(
      codeId: "#122000",
      caller: this,
      methodName: "checkBeforeViewingStageSubmit",
      suffixShortDesc: "",
    );
    Actionable<StageSubmitPrecheck> actionable =
        checkBeforeViewingStageSubmit();

    if (!actionable.yes) {
      _addErrorLogActionable(
        executionTrace: executionTrace,
        traceStepCodeId: "#122100",
        prefixShortDesc: 'checkBeforeViewingStageSubmit()',
        module: module,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return StageSubmitResult(precheck: actionable.errCode);
    }
    return await viewingStage!._submitAfterPrecheckSuccessful();
  }

  void reset() {
    // TODO...
  }

  void showDebugContextDataViewerDialog(BuildContext context) {
    // TODO...
  }

  void _broadcastProzessHidden() {
    // TODO...
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<StageRewindPrecheck> checkBeforeRewindFrontierToStage(
      STAGE_ENUM targetStageEnum) {
    final Stage? targetStage = findStage(targetStageEnum);

    return StageRewindPrecheckUtils.checkBeforeRewindFrontierToStage(
      checkBusy: true,
      isBusy: FlutterArtist.executor.isBusy,
      targetStageOrder: targetStage?.stageId.stageOrder,
      hasTargetStage: targetStage != null,
      targetStageIsSubmitted: targetStage?.isSubmitted ?? false,
      reexecutionAllowed: _isStageReexecutionAllowed,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<StageLoadInitDataPrecheck> checkBeforeViewingStageLoadInitData() {
    return __checkBeforeViewingStageLoadInitData(
      checkBusy: true,
      targetStage: viewingStage,
    );
  }

  Actionable<StageLoadInitDataPrecheck> __checkBeforeViewingStageLoadInitData({
    required bool checkBusy,
    required Stage? targetStage,
  }) {
    final Stage? frontierStage = findFrontierStage();
    final bool reexecutionAllowed = _isStageReexecutionAllowed;

    final int? targetStageOrder = targetStage?.stageId.stageOrder;
    final int? viewingStageOrder = viewingStage?.stageId.stageOrder;
    final int? frontierStageOrder = frontierStage?.stageId.stageOrder;

    final StageDataState targetStageDataState =
        targetStage?.dataState ?? StageDataStateNone();

    return StageLoadInitDataPrecheckUtils.checkBeforeLoadInitData(
      checkBusy: checkBusy,
      isBusy: FlutterArtist.executor.isBusy,
      targetStageOrder: targetStageOrder,
      viewingStageOrder: viewingStageOrder,
      frontierStageOrder: frontierStageOrder,
      targetStageDataState: targetStageDataState,
      reexecutionAllowed: reexecutionAllowed,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<StageSubmitPrecheck> checkBeforeViewingStageSubmit({
    bool checkValidate = true,
  }) {
    return __checkBeforeSubmitStage(
      checkBusy: true,
      checkTargetFormValidate: checkValidate,
      targetStage: viewingStage,
    );
  }

  @_PrecheckMethod()
  Actionable<StageSubmitPrecheck> __checkBeforeSubmitStage({
    required bool checkBusy,
    required bool checkTargetFormValidate,
    required Stage? targetStage,
  }) {
    final Stage? frontierStage = findFrontierStage();

    final int? targetStageOrder = targetStage?.stageId.stageOrder;
    final int? viewingStageOrder = viewingStage?.stageId.stageOrder;
    final int? frontierStageOrder = frontierStage?.stageId.stageOrder;

    final bool hasTargetForm = targetStage?.formModel != null;
    final StageDataState targetStageDataState =
        targetStage?.dataState ?? StageDataStateNone();

    final FormDataState targetFormDataState =
        targetStage?.formModel?.dataState ?? FormDataStateNone();

    //
    return StageSubmitPrecheckUtils.checkBeforeSubmit(
      checkBusy: checkBusy,
      isBusy: FlutterArtist.executor.isBusy,
      targetStageOrder: targetStageOrder,
      viewingStageOrder: viewingStageOrder,
      checkTargetFormValidate: checkTargetFormValidate,
      targetStageDataState: targetStageDataState,
      hasTargetForm: hasTargetForm,
      targetFormDataState: targetFormDataState,
      getActiveFormStates: targetStage?.formModel != null
          ? () => targetStage!.formModel!.ui._visibleFormBuilderStates
          : null,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _unitLoadInitData({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XProzess thisXProzess,
    required ProzessLoadInitDataIntent<STAGE_ENUM, PROZESS_INIT_DATA,
            PROZESS_CONTEXT_DATA>
        executionIntent,
  }) async {
    __assertThisXProzess(thisXProzess);

    thisXProzess._createAndSetProzessIntentDone(
      lastIntentInfo: "Load Init Data",
    );

    final executionResult = executionIntent.resultWrapper._setResult(
      ProzessLoadInitDataResult<STAGE_ENUM, PROZESS_INIT_DATA,
          PROZESS_CONTEXT_DATA>(precheck: null),
      objectCaller: this,
      methodName: '_unitLoadInitData',
    );
    PROZESS_INIT_DATA? prozessInitData;
    ProzessErrorInfo? prozessErrorInfo;
    try {
      debug._performLoadInitDataCount++;

      ApiResult<PROZESS_INIT_DATA> result = await performLoadInitData();
      result.throwIfError();
      prozessInitData = result.data;

      if (prozessInitData == null) {
        if (PROZESS_INIT_DATA == EmptyProzessInitData) {
          prozessInitData = EmptyProzessInitData() as PROZESS_INIT_DATA;
        }
      }
      if (prozessInitData == null) {
        throw AppError(
          errorMessage:
              "${getClassName(this)}.performLoadInitData() return null InitData",
        );
      }
    } catch (e, stackTrace) {
      prozessErrorInfo = ProzessErrorInfo(
        prozessErrorMethod: ProzessErrorMethod.performLoadInitData,
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
      // Pending or LoadedStale.
      _dataState = ProzessDataStateUtils.calculateDataStateOnLoadInitDataError(
        currentDataState: _dataState,
        errorInfo: prozessErrorInfo,
        hasExistingInitData: _prozessInitData != null,
      );
      return;
    }
    //
    // Now `prozessInitData` is not null.
    //
    try {
      _isStageReexecutionAllowed = isStageReexecutionAllowed(
        prozessInitData: prozessInitData,
      );
    } catch (e, stackTrace) {
      _isStageReexecutionAllowed = false;

      prozessErrorInfo = ProzessErrorInfo(
        prozessErrorMethod: ProzessErrorMethod.isStageReexecutionAllowed,
        error: e,
        errorStackTrace: stackTrace,
      );

      final ErrorInfo errorInfo = _handleError(
        module: null,
        methodName: "isStageReexecutionAllowed",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );

      executionResult._setErrorInfo(errorInfo: errorInfo);
      // Pending or LoadedStale.
      _dataState = ProzessDataStateUtils.calculateDataStateOnLoadInitDataError(
        currentDataState: _dataState,
        errorInfo: prozessErrorInfo,
        hasExistingInitData: _prozessInitData != null,
      );
      return;
    }
    // Create createProzessContextData()
    try {
      _prozessContextData = createProzessContextData(
        prozessInitData: prozessInitData,
      );
    } catch (e, stackTrace) {
      prozessErrorInfo = ProzessErrorInfo(
        prozessErrorMethod: ProzessErrorMethod.createProzessContextData,
        error: e,
        errorStackTrace: stackTrace,
      );

      final ErrorInfo errorInfo = _handleError(
        module: null,
        methodName: "createProzessContextData",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );

      executionResult._setErrorInfo(errorInfo: errorInfo);
      // Pending or LoadedStale.
      _dataState = ProzessDataStateUtils.calculateDataStateOnLoadInitDataError(
        currentDataState: _dataState,
        errorInfo: prozessErrorInfo,
        hasExistingInitData: _prozessInitData != null,
      );
      return;
    }
    _prozessInitData = prozessInitData;
    _dataState = ProzessDataStateLoadedFresh();
    thisXProzess._createAndSetProzessIntentDetermineNextStage(
      prozessInitData: prozessInitData,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _unitDetermineNextStage({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XProzess thisXProzess,
    required ProzessDetermineNextStageIntent<
            STAGE_ENUM, //
            PROZESS_INIT_DATA,
            PROZESS_CONTEXT_DATA>
        executionIntent,
  }) async {
    __assertThisXProzess(thisXProzess);

    thisXProzess._createAndSetProzessIntentDone(
      lastIntentInfo: "Determine Next Stage",
    );

    final executionResult = executionIntent.resultWrapper._setResult(
      ProzessDetermineNextStageResult<STAGE_ENUM, PROZESS_INIT_DATA,
          PROZESS_CONTEXT_DATA>(precheck: null),
      objectCaller: this,
      methodName: '_unitDetermineNextStage',
    );
    //
    // IMPORTANT: Guaranteed to be non-null.
    //
    final PROZESS_INIT_DATA prozessInitData = _prozessInitData!;
    final PROZESS_CONTEXT_DATA prozessContextData = _prozessContextData!;
    // Reset ProzessContextData:
    try {
      executionTrace.addControllableCall(
        codeId: "#124100",
        caller: prozessContextData,
        methodName: 'reset',
        suffixShortDesc: "",
      );
      prozessContextData.reset();
    } catch (e, stackTrace) {
      ProzessErrorInfo prozessErrorInfo = ProzessErrorInfo(
        prozessErrorMethod: ProzessErrorMethod.contextDataReset,
        error: e,
        errorStackTrace: stackTrace,
      );
      final ErrorInfo errorInfo = _handleError(
        module: module,
        methodName: "reset",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      executionResult._setErrorInfo(errorInfo: errorInfo);
      // ProzessDataStateTransitioningFailed.
      _dataState =
          ProzessDataStateUtils.calculateDataStateOnDetermineNextStageError(
        currentDataState: _dataState,
        errorInfo: prozessErrorInfo,
      );
      return;
    }
    try {
      executionTrace.addInfo(
        codeId: "#124200",
        shortDesc: "Debug",
        parameters: {
          "orderedActiveStages": orderedActiveStages,
        },
      );
      executionTrace.addNonControllableCall(
        codeId: "#124400",
        caller: prozessContextData,
        methodName: '_updateFromActiveStages',
        suffixShortDesc:
            "This method will call ${debugObjHtml(prozessContextData)}.updateFromActiveStage() method.",
        parameters: {
          "orderedActiveStages": orderedActiveStages,
        },
      );
      prozessContextData._updateFromActiveStages(orderedActiveStages);
    } catch (e, stackTrace) {
      ProzessErrorInfo prozessErrorInfo = ProzessErrorInfo(
        prozessErrorMethod: ProzessErrorMethod.contextDataUpdateFromActiveStage,
        error: e,
        errorStackTrace: stackTrace,
      );
      final ErrorInfo errorInfo = _handleError(
        module: module,
        methodName: "updateFromActiveStage",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      executionResult._setErrorInfo(errorInfo: errorInfo);
      // ProzessDataStateTransitioningFailed.
      _dataState =
          ProzessDataStateUtils.calculateDataStateOnDetermineNextStageError(
        currentDataState: _dataState,
        errorInfo: prozessErrorInfo,
      );
      return;
    }
    // Call determineNextStage() method.
    try {
      final Stage? currentFrontierStage = findFrontierStage();
      final STAGE_ENUM? currentFrontierStageEnum =
          currentFrontierStage?.stageId as STAGE_ENUM?;

      executionTrace.addInfo(
        codeId: "#124600",
        shortDesc: "Before call determineNextStage().",
        parameters: {
          "currentFrontierStageEnum": currentFrontierStageEnum,
          "viewingStageEnum": _viewingStageEnum,
          "orderedActiveStageEnums": orderedActiveStageEnums,
        },
      );

      final STAGE_ENUM? determinedNextStageEnum = determineNextStage(
        orderedActiveStageEnums: orderedActiveStageEnums,
        sharedContext: prozessContextData,
        prozessInitData: prozessInitData,
      );
      executionTrace.addInfo(
        codeId: "#124700",
        shortDesc: "After call determineNextStage().",
        parameters: {
          "determinedNextStageEnum": determinedNextStageEnum,
        },
      );

      // May throw AppError
      CheckNextStageUtils.checkDeterminedNextStage(
        viewingStageEnum: _viewingStageEnum,
        determinedNextStageEnum: determinedNextStageEnum,
      );
      // Now determinedNextStageEnum is valid.
      _dataState = ProzessDataStateTransitioningSuccess();
      if (determinedNextStageEnum != null) {
        final Stage determinedNextStage =
            findStageByEnum(determinedNextStageEnum);
        executionTrace.addInfo(
          codeId: "#124840",
          shortDesc:
              "Add ${debugObjHtml(determinedNextStage)} to Active Route.",
        );
        // New Frontier Stage:
        determinedNextStage._setStageRouteStatusToActive();

        for (Stage stage in _orderedStages) {
          if (stage._stageRouteStatus != StageRouteStatus.active &&
              stage.stageId.stageOrder <
                  determinedNextStage.stageId.stageOrder) {
            executionTrace.addInfo(
              codeId: "#124860",
              shortDesc:
                  "Set ${debugObjHtml(determinedNextStage)}.stageRouteStatus to Bypassed.",
            );
            stage._setStageRouteStatusToBypassed();
          }
        }
        determinedNextStage._dataState = StageDataStatePending();
        _viewingStageEnum = determinedNextStageEnum;
        executionTrace.addInfo(
          codeId: "#124900",
          shortDesc: "Debug.",
          parameters: {
            "viewingStageEnum": _viewingStageEnum,
            "orderedActiveStageEnums": orderedActiveStageEnums,
          },
        );
      }
    } catch (e, stackTrace) {
      ProzessErrorInfo prozessErrorInfo = ProzessErrorInfo(
        prozessErrorMethod: ProzessErrorMethod.determineInitialStage,
        error: e,
        errorStackTrace: stackTrace,
      );
      final ErrorInfo errorInfo = _handleError(
        module: null,
        methodName: "determineNextStage",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      executionResult._setErrorInfo(errorInfo: errorInfo);
      // ProzessDataStateTransitioningFailed.
      _dataState =
          ProzessDataStateUtils.calculateDataStateOnDetermineNextStageError(
        currentDataState: _dataState,
        errorInfo: prozessErrorInfo,
      );
      return;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void showProzessErrorViewerDialog(BuildContext context) {
    // TODO.
  }

  Future<void> loadInitData() async {
    // TODO.
  }

  Actionable<ShowFormInfoPrecheck> checkBeforeShowFormInfo() {
    BaseFormModel? formModel = viewingStage?.formModel;
    return __checkBeforeShowFormInfo(formModel: formModel);
  }

  Future<Actionable<ShowFormInfoPrecheck>>
      showViewingStageFormModelInspectorDialog() async {
    Actionable<ShowFormInfoPrecheck> actionable = checkBeforeShowFormInfo();
    if (!actionable.yes) {
      return actionable;
    }
    BaseFormModel? formModel = viewingStage?.formModel;
    await DebugFormModelInspectorDialog.show(
      context: FlutterArtistCore.context,
      locationInfo: getClassNameWithoutGenerics(this),
      formModel: formModel!,
    );
    return actionable;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _refreshProzessAfterChangeViewingStage() {
    ui.refreshAllViews(withStages: true, force: true);
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void __assertThisXProzess(XProzess thisXProzess) {
    if (thisXProzess.prozess != this || thisXProzess.name != name) {
      throw "Error Assert prozess: ${thisXProzess.prozess} - $this";
    }
  }
}
