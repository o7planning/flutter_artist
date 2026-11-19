part of '../core.dart';

abstract class Prozess<
        STAGE_ENUM extends StageEnum, //
        PROZESS_INIT_DATA extends ProzessInitData,
        PROZESS_CONTEXT_DATA extends ProzessContextData> extends _Core
    implements MnemonicScope, ClassDefViewable {
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

  PROZESS_CONTEXT_DATA? get prozessContextData => _prozessContextData;

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

  PROZESS_INIT_DATA? get prozessInitData => _prozessInitData;

  bool _isReexecutionAllowed = false;

  // ***************************************************************************
  // *** Constructor ***********************************************************
  // ***************************************************************************

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
      final stageEnum = stage.stageId;

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
        final aOrder = a.stageId.stageOrder;
        final bOrder = b.stageId.stageOrder;

        return aOrder.compareTo(bOrder);
      });

    // ===========================================================================
    // PHASE 3: REGISTER AND BIND
    // ===========================================================================
    final stageMap = <STAGE_ENUM, Stage>{};
    for (final stage in orderedStages) {
      final stageEnum = stage.stageId;

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

  @AbstractMethodAnnotation()
  ProzessStructure<STAGE_ENUM, PROZESS_CONTEXT_DATA> defineProzessStructure();

  @AbstractMethodAnnotation()
  Future<ApiResult<PROZESS_INIT_DATA>> performLoadInitData();

  @AbstractMethodAnnotation()
  STAGE_ENUM? determineNextStage({
    required List<STAGE_ENUM> orderedActiveStageEnums,
    required PROZESS_CONTEXT_DATA sharedContext,
    required PROZESS_INIT_DATA prozessInitData,
  });

  @AbstractMethodAnnotation()
  PROZESS_CONTEXT_DATA createProzessContextData({
    required PROZESS_INIT_DATA prozessInitData,
  });

  @AbstractMethodAnnotation()
  bool isReexecutionAllowed({required PROZESS_INIT_DATA prozessInitData});

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
    if (!lastActiveStage.dataState.isSubmissionSuccess) {
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

  /// Checks whether the form of the currently viewing stage can be reset.
  @_PrecheckMethod()
  Actionable<StageFormResetPrecheck> checkBeforeViewingStageFormReset({
    bool checkAllow = true,
  }) {
    final Stage? currentStage = viewingStage;
    if (currentStage == null) {
      return Actionable.no(
        errCode: StageFormResetPrecheck.noViewingStage,
      );
    }
    return currentStage.checkBeforeResetForm(checkAllow: checkAllow);
  }

  /// Resets the form of the currently viewing stage to its initial state.
  @_RootMethodAnnotation()
  void resetViewingStageForm() {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "resetViewingStageForm",
      parameters: null,
      isLibMethod: true,
    );

    final Actionable<StageFormResetPrecheck> actionable =
        checkBeforeViewingStageFormReset();

    if (!actionable.yes) {
      _addErrorLogActionable(
        executionTrace: executionTrace,
        traceStepCodeId: "#128100",
        prefixShortDesc: 'checkBeforeViewingStageFormReset()',
        module: module,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return;
    }

    viewingStage!.formModel!.resetForm();
  }

  // ===========================================================================
  // NEXT & PREVIOUS STAGE NAVIGATION CONTROLS
  // ===========================================================================

  @_PrecheckMethod()
  Actionable<ProzessMoveToNextStagePrecheck> checkBeforeMoveToNextStage() {
    return __checkBeforeMoveToNextStage(checkBusy: true);
  }

  @_PrecheckPrivateMethod()
  Actionable<ProzessMoveToNextStagePrecheck> __checkBeforeMoveToNextStage({
    required bool checkBusy,
  }) {
    final Stage? currentStage = viewingStage;
    final List<Stage> activeStages = orderedActiveStages;
    final int currentIndex =
        currentStage == null ? -1 : activeStages.indexOf(currentStage);

    return ProzessStageNavigationPrecheckUtils.checkBeforeMoveToNextStage(
      checkBusy: checkBusy,
      isBusy: FlutterArtist.executor.isBusy,
      hasViewingStage: _viewingStageEnum != null && currentStage != null,
      currentIndex: currentIndex,
      activeStagesCount: activeStages.length,
    );
  }

  @_PrecheckMethod()
  Actionable<ProzessMoveToPreviousStagePrecheck>
      checkBeforeMoveToPreviousStage() {
    return __checkBeforeMoveToPreviousStage(checkBusy: true);
  }

  @_PrecheckPrivateMethod()
  Actionable<ProzessMoveToPreviousStagePrecheck>
      __checkBeforeMoveToPreviousStage({
    required bool checkBusy,
  }) {
    final Stage? currentStage = viewingStage;
    final List<Stage> activeStages = orderedActiveStages;
    final int currentIndex =
        currentStage == null ? -1 : activeStages.indexOf(currentStage);

    return ProzessStageNavigationPrecheckUtils.checkBeforeMoveToPreviousStage(
      checkBusy: checkBusy,
      isBusy: FlutterArtist.executor.isBusy,
      hasViewingStage: _viewingStageEnum != null && currentStage != null,
      currentIndex: currentIndex,
    );
  }

  /// Evaluates whether the prozess can move forward to the next active stage in [orderedActiveStages].
  bool canMoveToNextStage() {
    return checkBeforeMoveToNextStage().yes;
  }

  /// Evaluates whether the prozess can move backward to the previous active stage in [orderedActiveStages].
  bool canMoveToPreviousStage() {
    return checkBeforeMoveToPreviousStage().yes;
  }

  /// Moves the viewing stage pointer forward to the next active stage in [orderedActiveStages].
  ///
  /// Returns `true` if successful, or `false` (with an error snackbar) if precheck fails.
  bool moveToNextStage() {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "moveToNextStage",
      parameters: null,
      isLibMethod: true,
    );

    final Actionable<ProzessMoveToNextStagePrecheck> actionable =
        checkBeforeMoveToNextStage();

    if (!actionable.yes) {
      _addErrorLogActionable(
        executionTrace: executionTrace,
        traceStepCodeId: "#127100",
        prefixShortDesc: 'checkBeforeMoveToNextStage()',
        module: module,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return false;
    }

    final List<Stage> activeStages = orderedActiveStages;
    final int currentIndex = activeStages.indexOf(viewingStage!);
    final Stage nextActiveStage = activeStages[currentIndex + 1];
    _viewingStageEnum = nextActiveStage.stageId as STAGE_ENUM;

    // Refresh UI to display the next active stage view and form.
    _refreshProzessAfterChangeViewingStage();
    return true;
  }

  /// Moves the viewing stage pointer backward to the previous active stage in [orderedActiveStages].
  ///
  /// Returns `true` if successful, or `false` (with an error snackbar) if precheck fails.
  bool moveToPreviousStage() {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "moveToPreviousStage",
      parameters: null,
      isLibMethod: true,
    );

    final Actionable<ProzessMoveToPreviousStagePrecheck> actionable =
        checkBeforeMoveToPreviousStage();

    if (!actionable.yes) {
      _addErrorLogActionable(
        executionTrace: executionTrace,
        traceStepCodeId: "#127200",
        prefixShortDesc: 'checkBeforeMoveToPreviousStage()',
        module: module,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return false;
    }

    final List<Stage> activeStages = orderedActiveStages;
    final int currentIndex = activeStages.indexOf(viewingStage!);
    final Stage prevActiveStage = activeStages[currentIndex - 1];
    _viewingStageEnum = prevActiveStage.stageId as STAGE_ENUM;

    // Refresh UI to display the previous active stage view and form.
    _refreshProzessAfterChangeViewingStage();
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _showConfirmRestartStageDialog() async {
    return await ProzessRestartConfirmDialog.show(
      context: FlutterArtistCore.context,
      prozess: this,
      targetStage: viewingStage,
      mode: _RestartConfirmMode.stage,
    );
  }

  Future<bool> _showConfirmRestartProzessDialog() async {
    return await ProzessRestartConfirmDialog.show(
      context: FlutterArtistCore.context,
      prozess: this,
      targetStage: null,
      mode: _RestartConfirmMode.process,
    );
  }

  // ===========================================================================
  // 🚀 RESTART PROZESS
  // ===========================================================================

  /// Restarts the entire Prozess from the beginning.
  Future<ProzessRestartResult> restart({bool askConfirm = true}) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "restart",
      parameters: {"askConfirm": askConfirm},
      isLibMethod: true,
    );

    // 1. Precheck
    final Actionable<ProzessRestartPrecheck> actionable = checkBeforeRestart();

    if (!actionable.yes) {
      _addErrorLogActionable(
        executionTrace: executionTrace,
        traceStepCodeId: "#115200",
        prefixShortDesc: 'checkBeforeRestart()',
        module: module,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return ProzessRestartResult(precheck: actionable.errCode!);
    }

    // 2. Confirm Dialog
    if (askConfirm) {
      bool confirm = await _showConfirmRestartProzessDialog();
      if (!confirm) {
        return ProzessRestartResult(precheck: ProzessRestartPrecheck.cancelled);
      }
    }
    final XActivity xActivity = _XActivityProzessStart(prozess: this);
    final thisXProzess = xActivity.findXProzessByName(name) as XProzess<
        STAGE_ENUM, //
        PROZESS_INIT_DATA,
        PROZESS_CONTEXT_DATA>;
    final ProzessRestartIntent<
            STAGE_ENUM, //
            PROZESS_INIT_DATA,
            PROZESS_CONTEXT_DATA> executionIntent =
        thisXProzess._createAndSetProzessIntentRestart();

    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xActivity);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    return executionIntent.result;
  }

  // ===========================================================================
  // 🔄 RESTART VIEWING STAGE
  // ===========================================================================

  /// Restarts the currently viewing stage.
  /// Asks for user confirmation before proceeding.
  Future<StageRestartResult> restartViewingStage({
    bool askConfirm = true,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "restartViewingStage",
      parameters: {"askConfirm": askConfirm},
      isLibMethod: true,
    );

    // 1. Precheck
    final Actionable<StageRestartPrecheck> actionable =
        checkBeforeViewingStageRestart();

    if (!actionable.yes) {
      _addErrorLogActionable(
        executionTrace: executionTrace,
        traceStepCodeId: "#126100",
        prefixShortDesc: 'checkBeforeViewingStageRestart()',
        module: module,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return StageRestartResult(precheck: actionable.errCode!);
    }

    // 2. Confirm Dialog
    if (askConfirm) {
      bool confirm = await _showConfirmRestartStageDialog();
      if (!confirm) {
        return StageRestartResult(
          precheck: StageRestartPrecheck.cancelled,
        );
      }
    }

    // 3. Reset Stage State
    _resetProzessAndStageStateInternal(viewingStage!);

    // 4. Load Stage Init Data
    return await viewingStage!._restartAfterPrecheckSuccessful();
  }

  void _resetProzessAndStageStateInternal(Stage stage) {
    _dataState = ProzessDataStateTransitionSuccess();
    stage._dataState = const StageDataStatePending();

    if (stage.formModel != null) {
      stage.formModel!._clearDataWithDataState(
        formDataState: const FormDataStatePending(),
      );
    }

    bool pastTargetStage = false;
    for (var s in _orderedStages) {
      if (s.stageId == stage.stageId) {
        pastTargetStage = true;
        continue;
      }
      if (pastTargetStage) {
        s._dataState = const StageDataStateNone();
        s._stageRouteStatus = StageRouteStatus.unreached;
        s.formModel?._clearDataWithDataState(
          formDataState: const FormDataStateNone(),
        );
      }
    }
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
      if (actionable.errCode == StageSubmitPrecheck.formInvalidated) {
        viewingStage?.formModel?.ui.focusFirstErrorField();
      }
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

  void showDebugContextDataViewerDialog(BuildContext context) {
    // TODO...
  }

  void _broadcastProzessHidden() {
    // TODO...
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<ShowFormModelInspectorPrecheck>
      checkBeforeShowViewingStageFormModelInspector() {
    BaseFormModel? formModel = viewingStage?.formModel;
    if (formModel == null) {
      return Actionable.no(
        errCode: ShowFormModelInspectorPrecheck.noForm,
      );
    }
    return formModel.checkBeforeShowFormModelInspector();
  }

  @_RootMethodAnnotation()
  Future<Actionable<ShowFormModelInspectorPrecheck>>
      showDebugViewingStageFormModelInspectorDialog() async {
    final actionable = checkBeforeShowViewingStageFormModelInspector();
    if (!actionable.yes) {
      final ShowFormModelInspectorPrecheck err = actionable.errCode!;
      showErrorSnackBar(
        message: err.message,
        errorDetails: err.details,
      );
      return actionable;
    }
    BaseFormModel? formModel = viewingStage?.formModel;
    return await formModel!.showDebugFormModelInspectorDialog(
      locationInfo: getClassNameWithoutGenerics(this),
    );
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
      reexecutionAllowed: _isReexecutionAllowed,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<StageRestartPrecheck> checkBeforeViewingStageRestart() {
    return __checkBeforeViewingStageRestart(
      checkBusy: true,
      targetStage: viewingStage,
    );
  }

  void cancel() {
    //
  }

  Actionable<StageRestartPrecheck> __checkBeforeViewingStageRestart({
    required bool checkBusy,
    required Stage? targetStage,
  }) {
    return StageRestartPrecheckUtils.checkBeforeRestartStage(
      checkBusy: checkBusy,
      isBusy: FlutterArtist.executor.isBusy,
      targetStage: targetStage,
      isRestartAllowed: true,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<ProzessRestartPrecheck> checkBeforeRestart({
    bool checkValidate = true,
  }) {
    return _checkBeforeRestart(
      checkBusy: true,
    );
  }

  Actionable<ProzessRestartPrecheck> _checkBeforeRestart({
    required bool checkBusy,
  }) {
    return ProzessRestartPrecheckUtils.checkBeforeRestart(
      checkBusy: checkBusy,
      isBusy: FlutterArtist.executor.isBusy,
    );
  }

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

  Future<void> _unitRestartProzess({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XProzess thisXProzess,
    required ProzessRestartIntent<STAGE_ENUM, PROZESS_INIT_DATA,
            PROZESS_CONTEXT_DATA>
        executionIntent,
  }) async {
    __assertThisXProzess(thisXProzess);

    thisXProzess._createAndSetProzessIntentDone(
      lastIntentInfo: "Load Init Data",
    );

    final executionResult = executionIntent.resultWrapper._setResult(
      ProzessRestartResult<
          STAGE_ENUM, //
          PROZESS_INIT_DATA,
          PROZESS_CONTEXT_DATA>(
        precheck: null,
      ),
      objectCaller: this,
      methodName: '_unitRestartProzess',
    );
    ProzessErrorInfo? prozessErrorInfo;
    try {
      executionTrace.addNonControllableCall(
        codeId: "#116040",
        caller: this,
        methodName: '_resetProzessStateInternal',
        suffixShortDesc: '',
      );
      _resetProzessStateInternal();
    } catch (e, stackTrace) {
      prozessErrorInfo = ProzessErrorInfo(
        prozessErrorMethod: ProzessErrorMethod.resetProzessStateInternal,
        error: e,
        errorStackTrace: stackTrace,
      );

      final ErrorInfo errorInfo = _handleError(
        module: module,
        methodName: "_resetProzessStateInternal",
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
    PROZESS_INIT_DATA? prozessInitData;
    try {
      executionTrace.addControllableCall(
        codeId: "#116600",
        caller: this,
        methodName: 'performLoadInitData',
        suffixShortDesc: '',
      );
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
        module: module,
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
      executionTrace.addControllableCall(
        codeId: "#116700",
        caller: this,
        methodName: 'isReexecutionAllowed',
        suffixShortDesc: '',
      );
      _isReexecutionAllowed = isReexecutionAllowed(
        prozessInitData: prozessInitData,
      );
    } catch (e, stackTrace) {
      _isReexecutionAllowed = false;

      prozessErrorInfo = ProzessErrorInfo(
        prozessErrorMethod: ProzessErrorMethod.isReexecutionAllowed,
        error: e,
        errorStackTrace: stackTrace,
      );

      final ErrorInfo errorInfo = _handleError(
        module: module,
        methodName: "isReexecutionAllowed",
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
      executionTrace.addControllableCall(
        codeId: "#116800",
        caller: this,
        methodName: 'createProzessContextData',
        suffixShortDesc: '',
      );
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
        module: module,
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

    executionTrace.addInfo(
      codeId: "#116900",
      shortDesc: 'Create ${debugObjHtml(ProzessDetermineNextStageIntent)}.',
    );
    thisXProzess._createAndSetProzessIntentDetermineNextStage(
      prozessInitData: prozessInitData,
    );
  }

  // ***************************************************************************

  void _resetProzessStateInternal() {
    _dataState = ProzessDataStatePending();
    _prozessInitData = null;
    _prozessContextData?.reset();
    _viewingStageEnum = null;

    for (var stage in _orderedStages) {
      stage._resetStageStateInternal();
    }
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
    //
    STAGE_ENUM? determinedNextStageEnum;
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
      determinedNextStageEnum = determineNextStage(
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
      //
      // May throw AppError.
      //
      CheckNextStageUtils.checkDeterminedNextStage(
        viewingStageEnum: _viewingStageEnum,
        determinedNextStageEnum: determinedNextStageEnum,
      );
      // Now determinedNextStageEnum is valid.
      _dataState = ProzessDataStateTransitionSuccess();
    } catch (e, stackTrace) {
      ProzessErrorInfo prozessErrorInfo = ProzessErrorInfo(
        prozessErrorMethod: ProzessErrorMethod.determineInitialStage,
        error: e,
        errorStackTrace: stackTrace,
      );
      final ErrorInfo errorInfo = _handleError(
        module: module,
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
    //
    // determinedNextStageEnum == null
    //
    //*** In _process.dart (_unitDetermineNextStage method) ***//

    //
    // determinedNextStageEnum == null (No more stages -> Workflow finished)
    //
    if (determinedNextStageEnum == null) {
      // =======================================================================
      // AUTOMATIC SESSION ESTABLISHMENT (If this Prozess is a SessionEstablisher)
      // =======================================================================
      if (this is SessionEstablisher) {
        try {
          final ILoggedInUser? authenticatedUser =
              (this as SessionEstablisher).extractAuthenticatedUser();

          final bool sessionSuccess =
              await FlutterArtist.globalsManager._establishSessionFromWorkflow(
            executionTrace: executionTrace,
            workflowUnit: this,
            loggedInUser: authenticatedUser,
          );

          if (!sessionSuccess) {
            throw AppError(
              errorMessage:
                  "Failed to initialize global user session and application data.",
            );
          }
        } catch (e, stackTrace) {
          final ProzessErrorInfo prozessErrorInfo = ProzessErrorInfo(
            prozessErrorMethod: ProzessErrorMethod.determineInitialStage,
            error: e,
            errorStackTrace: stackTrace,
          );
          final ErrorInfo errorInfo = _handleError(
            module: module,
            methodName: "establishSession",
            error: e,
            stackTrace: stackTrace,
            showSnackBar: true,
            tipDocument: null,
          );
          executionResult._setErrorInfo(errorInfo: errorInfo);
          _dataState =
              ProzessDataStateUtils.calculateDataStateOnDetermineNextStageError(
            currentDataState: _dataState,
            errorInfo: prozessErrorInfo,
          );
          return;
        }
      }

      _dataState = const ProzessDataStateCompleted();
      await __onProzessCompletedInternal();
    }
    // determinedNextStageEnum != null
    else {
      final Stage determinedNextStage =
          findStageByEnum(determinedNextStageEnum);
      executionTrace.addInfo(
        codeId: "#124840",
        shortDesc: "Add ${debugObjHtml(determinedNextStage)} to Active Route.",
      );
      // New Frontier Stage:
      determinedNextStage._setStageRouteStatusToActive();

      for (Stage stage in _orderedStages) {
        if (stage._stageRouteStatus != StageRouteStatus.active &&
            stage.stageId.stageOrder < determinedNextStage.stageId.stageOrder) {
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
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> __onProzessCompletedInternal() async {
    try {
      await onProzessCompleted();
      //
      _dataState = ProzessDataStateCompleted();
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        module: module,
        methodName: "onProzessCompleted",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> onProzessCompleted() async {
    //
  }

  // ***************************************************************************
  // ***************************************************************************

  void showProzessErrorViewerDialog(BuildContext context) {
    // TODO.
  }

  // ***************************************************************************
  // ***************************************************************************

  void _refreshProzessAfterChangeViewingStage() {
    module.ui.refreshAllViews();
    FlutterArtist.storage.ui.refreshAllViews();
  }

  // ***************************************************************************
  // ***************************************************************************

  void _processNavigationIntent(
    BuildContext context, {
    Object? result,
    required NavigationIntent intent,
  }) {
    // TODO
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
