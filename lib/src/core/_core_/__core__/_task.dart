part of '../core.dart';

/// Represents a standalone transactional unit of work within an Activity.
///
/// Lifecycle:
/// [TaskDataStatePending] -> (loads INIT_DATA) -> [TaskDataStateLoadedFresh]
/// -> (submission) -> [TaskDataStateSubmissionAttempted]
abstract class Task<
    INIT_DATA extends TaskInitData, //
    RESULT_DATA extends TaskResultData, //
    FORM_INPUT extends FormInput,
    FORM_OUTPUT extends FormOutput> extends WorkNode<
    INIT_DATA, //
    RESULT_DATA, //
    FORM_INPUT,
    FORM_OUTPUT> implements FormHost, ClassDefViewable {
  @override
  Map<String, Type> getGenericsInfoMap() {
    return {
      "INIT_DATA": INIT_DATA,
      "RESULT_DATA": RESULT_DATA,
      "FORM_INPUT": FORM_INPUT,
      "FORM_OUTPUT": FORM_OUTPUT,
    };
  }

  final TaskConfig config;
  final TaskEffectiveConfig effectiveConfig;

  late final debug = _TaskDebugInfo(task: this);

  @override
  late final Activity activity;

  @override
  Activity get module => activity;

  late final ui = _TaskUiComponents(task: this);

  @override
  TaskFormModel<
      INIT_DATA, //
      RESULT_DATA,
      FORM_INPUT,
      FORM_OUTPUT,
      AdditionalFormRelatedData>? formModel;

  // ===========================================================================
  // EMBEDDED TASK STATE STORAGE
  // ===========================================================================

  TaskDataState _dataState = const TaskDataStatePending.initial();

  TaskDataState get dataState => _dataState;

  @override
  bool get hasForm => formModel != null;

  @override
  bool get hasError => _dataState.hasError;

  TaskErrorInfo? get errorInfo => _dataState.errorInfo;

  // ===========================================================================
  // DYNAMIC CONFIGURATION STATE
  // ===========================================================================

  bool _isReexecutionAllowed = false;

  bool _isMultipleSubmissionsAllowed = false;

  // ===========================================================================
  // Constructor
  // ===========================================================================

  Task({
    required super.name,
    super.description,
    this.config = const TaskConfig(),
    required this.formModel,
  }) : effectiveConfig = TaskEffectiveConfig.fromConfig(config) {
    formModel?._bindToTask(this);
  }

  // ===========================================================================

  XTask _createXTask({
    required XActivity xActivity,
    required XTaskFormModel? xTaskFormModel,
  }) {
    return XTask<
        INIT_DATA, //
        RESULT_DATA,
        FORM_INPUT,
        FORM_OUTPUT>._(
      xActivity: xActivity,
      task: this,
      xTaskFormModel: xTaskFormModel,
    );
  }

  // ===========================================================================

  void _bindToActivity(Activity parentActivity) {
    activity = parentActivity;
  }

  @override
  void _refreshControlBars() {
    ui.refreshControlBars();
  }

  // ===========================================================================
  // UI & CONFIRMATION HOOKS
  // ===========================================================================

  @OverridableMethodAnnotation()
  CustomConfirmation? createCustomRestartConfirmation() {
    return null;
  }

  @OverridableMethodAnnotation()
  String get restartConfirmMessage =>
      "Are you sure you want to restart this task? "
      "All current progress and unsaved data will be cleared.";

  // ===========================================================================
  // ABSTRACT CONTRACTS
  // ===========================================================================

  @AbstractMethodAnnotation()
  Future<ApiResult<INIT_DATA>> performLoadInitData();

  @AbstractMethodAnnotation()
  Future<ApiResult<RESULT_DATA>> performSubmit({
    required INIT_DATA initData,
    required FORM_OUTPUT? formData,
  });

  @AbstractMethodAnnotation()
  Future<void> onTaskCompleted();

  /// Evaluates whether this Task can be restarted to reload data and reset progress.
  @AbstractMethodAnnotation()
  bool isReexecutionAllowed({required INIT_DATA initData});

  /// Evaluates whether this Task permits submitting new forms repeatedly
  /// without requiring a full restart.
  @AbstractMethodAnnotation()
  bool isMultipleSubmissionsAllowed({required INIT_DATA initData});

  // ===========================================================================
  // INTERNAL STATE RESET
  // ===========================================================================

  void _resetTaskStateInternal() {
    _dataState = const TaskDataStatePending.initial();
    // Clears _initData and _submitResultData inherited from WorkNode.
    _clearData();

    if (formModel != null) {
      formModel!._clearDataWithDataState(
        formDataState: const FormDataStatePending(),
      );
    }
  }

  // ===========================================================================
  // EXECUTION UNIT: _unitRestart
  // ===========================================================================

  @_ExecutionUnitMethodAnnotation()
  Future<void> _unitRestart({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XTask thisXTask,
    required TaskRestartIntent<INIT_DATA, RESULT_DATA> executionIntent,
  }) async {
    __assertThisXTask(thisXTask);
    thisXTask._createAndSetTaskIntentDone(
      lastIntentInfo: "Restart",
    );

    final ExecHint initialExecHint = thisXTask.execHint;
    thisXTask.resetExecutionHints();

    executionTrace.addInfo(
      codeId: "#090100",
      shortDesc:
          "${debugObjHtml(this)} -> Begin ${executionUnitType.asDebugExecutionUnit()} (Restart Task)",
    );

    final executionResult = executionIntent.resultWrapper._setResult(
      TaskRestartResult<INIT_DATA, RESULT_DATA>(precheck: null),
      objectCaller: this,
      methodName: '_unitRestart',
    );

    TaskErrorInfo? taskErrorInfo;

    // 1. Reset Internal State
    try {
      executionTrace.addNonControllableCall(
        codeId: "#090140",
        caller: this,
        methodName: '_resetTaskStateInternal',
        suffixShortDesc: '',
      );
      _resetTaskStateInternal();
    } catch (e, stackTrace) {
      taskErrorInfo = TaskErrorInfo(
        taskErrorMethod: TaskErrorMethod.resetTaskStateInternal,
        error: e,
        errorStackTrace: stackTrace,
      );

      final ErrorInfo errorInfo = _handleError(
        module: module,
        methodName: "_resetTaskStateInternal",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      executionResult._setErrorInfo(errorInfo: errorInfo);
      // TODO Xem lai.........
      _dataState = TaskDataStatePending.failed(errorInfo: taskErrorInfo);
      return;
    }

    INIT_DATA? taskInitData;

    // 2. Fetch INIT_DATA
    try {
      __refreshLoadingInitDataState(isLoading: true);

      executionTrace.addControllableCall(
        codeId: "#090200",
        caller: this,
        methodName: "performLoadInitData",
        suffixShortDesc: "",
      );
      debug._performLoadInitDataCount++;

      final ApiResult<INIT_DATA> result = await performLoadInitData();
      result.throwIfError();
      taskInitData = result.data;

      if (taskInitData == null) {
        if (INIT_DATA == EmptyTaskInitData) {
          taskInitData = EmptyTaskInitData() as INIT_DATA;
        }
      }
      if (taskInitData == null) {
        throw AppError(
          errorMessage:
              "${getClassName(this)}.performLoadInitData() return null InitData",
        );
      }
    } catch (e, stackTrace) {
      taskErrorInfo = TaskErrorInfo(
        taskErrorMethod: TaskErrorMethod.performLoadInitData,
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
      _dataState = TaskDataStatePending.failed(errorInfo: taskErrorInfo);

      if (formModel != null) {
        final newFormDataState =
            TaskFormDataStateUtils.calculateNewLazyDataState(
          currentFormDataState: formModel!.dataState,
          taskDataState: _dataState,
          hasInitData: _initData != null,
        );
        formModel!._formModelStructure._setFormDataState(
          formDataState: newFormDataState,
          error: null,
        );
      }

      executionTrace.addInfo(
        codeId: "#090500",
        shortDesc:
            "The ${debugObjHtml(this)}.performLoadInitData() method encountered an error!",
        errorInfo: errorInfo,
      );
      __refreshLoadingInitDataState(isLoading: false);
      return;
    }

    // 3.1 Evaluate Dynamic Rules via Initial Data
    try {
      executionTrace.addControllableCall(
        codeId: "#090600",
        caller: this,
        methodName: 'isReexecutionAllowed',
        suffixShortDesc: '',
      );
      _isReexecutionAllowed = isReexecutionAllowed(initData: taskInitData);
    } catch (e, stackTrace) {
      _isReexecutionAllowed = false;

      taskErrorInfo = TaskErrorInfo(
        taskErrorMethod: TaskErrorMethod.isReexecutionAllowed,
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
      _dataState = TaskDataStatePending.failed(errorInfo: taskErrorInfo);
      __refreshLoadingInitDataState(isLoading: false);
      return;
    }

    // 3.2 Evaluate Dynamic Rules via Initial Data
    try {
      executionTrace.addControllableCall(
        codeId: "#090720",
        caller: this,
        methodName: 'isMultipleSubmissionsAllowed',
        suffixShortDesc: '',
      );
      _isMultipleSubmissionsAllowed =
          isMultipleSubmissionsAllowed(initData: taskInitData);
    } catch (e, stackTrace) {
      _isMultipleSubmissionsAllowed = false;

      taskErrorInfo = TaskErrorInfo(
        taskErrorMethod: TaskErrorMethod.isMultipleSubmissionsAllowed,
        error: e,
        errorStackTrace: stackTrace,
      );

      final ErrorInfo errorInfo = _handleError(
        module: module,
        methodName: "isMultipleSubmissionsAllowed",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );

      executionResult._setErrorInfo(errorInfo: errorInfo);
      _dataState = TaskDataStatePending.failed(errorInfo: taskErrorInfo);
      __refreshLoadingInitDataState(isLoading: false);
      return;
    }

    // 4. Commit State Transition
    _initData = taskInitData;
    _dataState = const TaskDataStateLoadedFresh();
    __refreshLoadingInitDataState(isLoading: false);

    executionTrace.addInfo(
      codeId: "#090240",
      shortDesc: "INIT_DATA loaded successfully.",
      parameters: {
        "initData": _initData,
        "dataState": _dataState,
        "isReexecutionAllowed": _isReexecutionAllowed,
        "isMultipleSubmissionsAllowed": _isMultipleSubmissionsAllowed,
      },
    );

    // 5. Coordinate FormModel Lifecycle
    if (formModel != null) {
      final newFormDataState = TaskFormDataStateUtils.calculateNewLazyDataState(
        currentFormDataState: formModel!.dataState,
        taskDataState: _dataState,
        hasInitData: _initData != null,
      );
      executionTrace.addInfo(
        codeId: "#090300",
        shortDesc:
            "Transitioning FormModel state to ${newFormDataState.toBriefInfo()}.",
      );
      formModel!._formModelStructure._setFormDataState(
        formDataState: newFormDataState,
        error: null,
      );
    }
  }

  // ===========================================================================
  // EXECUTION UNIT: _unitSubmit
  // ===========================================================================

  Future<void> _unitSubmit({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XTask<INIT_DATA, RESULT_DATA, FORM_INPUT, FORM_OUTPUT> thisXTask,
    required TaskSubmitIntent<INIT_DATA, RESULT_DATA, FORM_OUTPUT>
        executionIntent,
  }) async {
    __assertThisXTask(thisXTask);
    thisXTask._createAndSetTaskIntentDone(
      lastIntentInfo: "Submit",
    );

    executionTrace.addInfo(
      codeId: "#093100",
      shortDesc:
          "${debugObjHtml(this)} -> Begin ${executionUnitType.asDebugExecutionUnit()} (Submit)",
    );

    final executionResult = executionIntent.resultWrapper._setResult(
      TaskSubmitExecutionResult<INIT_DATA, RESULT_DATA>(precheck: null),
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
      TaskErrorInfo taskErrorInfo = TaskErrorInfo(
        taskErrorMethod: TaskErrorMethod.convertToFormOutput,
        error: e,
        errorStackTrace: stackTrace,
      );
      _dataState = TaskDataStateSubmissionFailed(
        submissionErrorInfo: taskErrorInfo,
      );
      return;
    }
    try {
      ApiResult<RESULT_DATA> result = await performSubmit(
        initData: initData!,
        formData: formOutput,
      );
      result.throwIfError();
      final RESULT_DATA? data = result.data;
      if (data == null) {
        throw ApiError(
          errorMessage:
              "${getClassNameWithoutGenerics(this)}.performSubmit() return ResultData null",
        );
      }
      _submitResultData = data;
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
      final TaskErrorInfo taskErrorInfo = TaskErrorInfo(
        taskErrorMethod: TaskErrorMethod.performSubmit,
        error: e,
        errorStackTrace: stackTrace,
      );
      _dataState = TaskDataStateSubmissionFailed(
        submissionErrorInfo: taskErrorInfo,
      );
      return;
    }
    // =======================================================================
    // AUTOMATIC SESSION ESTABLISHMENT (If this Task is a SessionEstablisher)
    // =======================================================================
    if (this is SessionEstablisher) {
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
    }
    // -------------------------------------------------------------------------
    // COMPLETE:
    // -------------------------------------------------------------------------
    _dataState = TaskDataStateCompleted();
    await __onTaskCompleted();
    //
  }

  Future<void> __onTaskCompleted() async {
    try {
      await onTaskCompleted();
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        module: module,
        methodName: "onTaskCompleted",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
    }
  }

  // ===========================================================================
  // PUBLIC CONTROLS
  // ===========================================================================

  Future<TaskRestartResult<INIT_DATA, RESULT_DATA>> restart({
    bool askConfirm = true,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "restart",
      parameters: null,
      isLibMethod: true,
    );
    final bool checkAllowTrue = true;

    executionTrace.addNonControllableCall(
      codeId: "#114000",
      caller: this,
      methodName: "checkBeforeRestart",
      suffixShortDesc: "",
      parameters: {
        "checkAllow": checkAllowTrue,
      },
    );

    final Actionable<TaskRestartPrecheck> actionable = checkBeforeRestart(
      checkAllow: checkAllowTrue,
    );

    if (!actionable.yes) {
      // debug._deletionErrorCount++;
      _addErrorLogActionable(
        executionTrace: executionTrace,
        traceStepCodeId: "#114100",
        prefixShortDesc: 'checkBeforeRestart()',
        module: activity,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return TaskRestartResult<INIT_DATA, RESULT_DATA>(
        precheck: actionable.errCode,
      );
    }

    // 2. Confirm Dialog
    if (askConfirm) {
      bool confirm = await _showConfirmRestartTaskDialog();
      if (!confirm) {
        return TaskRestartResult(precheck: TaskRestartPrecheck.cancelled);
      }
    }

    final XActivity xActivity = _XActivityTaskRestart(task: this);
    final thisXTask = xActivity.findXTaskByName(name) as XTask<
        INIT_DATA, //
        RESULT_DATA,
        FORM_INPUT,
        FORM_OUTPUT>;
    final TaskRestartIntent<
            INIT_DATA, //
            RESULT_DATA> executionIntent =
        thisXTask._createAndSetTaskIntentRestart();

    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xActivity);
    await FlutterArtist.executor._executeExecutionUnitQueue();

    return executionIntent.result;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isLoadInitDataAllowed() {
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _showConfirmRestartTaskDialog() async {
    final customConfirm = createCustomRestartConfirmation();

    if (customConfirm != null) {
      return await customConfirm(FlutterArtistCore.context);
    } else {
      return await TaskRestartConfirmDialog.show(
        context: FlutterArtistCore.context,
        task: this,
      );
    }
  }

  // ***************************************************************************

  @_IsAllowPrivateMethodAnnotation()
  CheckAllowResult __checkRestartAllowed() {
    try {
      bool allow = isLoadInitDataAllowed();
      return allow ? CheckAllowResult.allowed() : CheckAllowResult.notAllowed();
    } catch (e, stackTrace) {
      return CheckAllowResult.error(
        errorInfo: ErrorInfo.fromError(
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  bool canLoadInitData() {
    final Actionable<TaskRestartPrecheck> actionable =
        checkBeforeRestart(checkAllow: true);
    return actionable.yes;
  }

  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<TaskRestartPrecheck> checkBeforeRestart({
    bool checkAllow = true,
  }) {
    return __checkBeforeRestart(
      checkBusy: true,
      checkAllow: checkAllow,
    );
  }

  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<TaskRestartPrecheck> __checkBeforeRestart({
    required bool checkBusy,
    required bool checkAllow,
  }) {
    return TaskRestartPrecheckUtils.checkBeforeRestart(
      checkBusy: true,
      isBusy: FlutterArtist.executor.isBusy,
      checkAllow: checkAllow,
      taskDataState: dataState,
      isReexecutionAllowed: _isReexecutionAllowed,
      checkRestartAllowed: () => __checkRestartAllowed(),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Evaluates whether this Task permits submitting its current state based on
  /// execution business rules, task data states, and form validation constraints.
  @_PrecheckPrivateMethod()
  Actionable<TaskSubmitPrecheck> __checkBeforeSubmit({
    required bool checkBusy,
    required bool checkAllow,
    required bool checkValidate,
  }) {
    return TaskSubmitPrecheckUtils.checkBeforeSubmit(
      checkBusy: checkBusy,
      isBusy: FlutterArtist.executor.isBusy,
      checkValidate: checkValidate,
      taskDataState: dataState,
      hasForm: formModel != null,
      formDataState: formModel?.dataState,
      getActiveFormStates: formModel != null
          ? () => formModel!.ui._visibleFormBuilderStates
          : null,
    );
  }

  // ***************************************************************************

  /// Public entry point evaluating whether this Task permits submitting its current state.
  @_PrecheckMethod()
  Actionable<TaskSubmitPrecheck> checkBeforeSubmit({
    bool checkAllow = true,
    bool checkValidate = true,
  }) {
    return __checkBeforeSubmit(
      checkBusy: true,
      checkAllow: checkAllow,
      checkValidate: checkValidate,
    );
  }

  // ***************************************************************************

  bool canSubmit() {
    final Actionable<TaskSubmitPrecheck> actionable = checkBeforeSubmit(
      checkAllow: true,
      checkValidate: true,
    );
    return actionable.yes;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isPendingOrStale({required bool requiresVisible}) {
    final bool visible = ui.hasVisibleViews();
    if (requiresVisible && !visible) {
      return false;
    }
    return dataState.isPending || dataState.isLoadedStale;
  }

  void showTaskErrorViewerDialog(BuildContext context) {
    if (errorInfo != null) {
      ErrorViewerDialog.show(
        context: context,
        errorInfo: errorInfo!.toErrorInfo(),
      );
    }
  }

  Future<TaskSubmitExecutionResult<INIT_DATA, RESULT_DATA>> submit() async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "submit",
      parameters: {},
      isLibMethod: true,
    );

    executionTrace.addNonControllableCall(
      codeId: "#094000",
      caller: this,
      methodName: "checkBeforeSubmit",
      suffixShortDesc: "",
    );
    Actionable<TaskSubmitPrecheck> actionable = checkBeforeSubmit();

    if (!actionable.yes) {
      _addErrorLogActionable(
        executionTrace: executionTrace,
        traceStepCodeId: "#094100",
        prefixShortDesc: 'checkBeforeSubmit()',
        module: module,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return TaskSubmitExecutionResult(precheck: actionable.errCode);
    }

    final XActivity xActivity = _XActivityTaskSubmit(task: this);
    final xTask = xActivity.findXTaskByName(name)
        as XTask<INIT_DATA, RESULT_DATA, FORM_INPUT, FORM_OUTPUT>;

    final TaskSubmitIntent<INIT_DATA, RESULT_DATA, FORM_OUTPUT>
        executionIntent = xTask._createAndSetTaskIntentSubmit();

    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xActivity);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    return executionIntent.result;
  }

  void _processNavigationIntent({
    required BuildContext context,
    required void result,
    required NavigationIntent intent,
  }) {
    // TODO..
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  bool isStateReadyForForm() {
    if (dataState.isPending || dataState.isLoadedStale) {
      return false;
    } else if (dataState.isLoadedFresh ||
        dataState.isCompleted ||
        dataState.isSubmissionFailed) {
      return true;
    } else {
      // Never run.
      throw UnimplementedError("Task: Never run");
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<TaskFormEnablePrecheck> checkFormEnable({
    bool checkAllow = true,
  }) {
    return __checkFormEnable(
      checkAllow: checkAllow,
    );
  }

  @_PrecheckPrivateMethod()
  Actionable<TaskFormEnablePrecheck> __checkFormEnable({
    bool checkAllow = true,
  }) {
    return TaskFormEnablePrecheckUtils.checkFormEnable(
      hasForm: formModel != null,
      taskDataState: dataState,
      formDataState: formModel?.dataState,
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
  // ***************************************************************************

  void _broadcastScalarHidden() {
    switch (effectiveConfig.onHideAction) {
      case TaskHiddenAction.none:
        break;
      case TaskHiddenAction.clear:
        break;
    }
  }

  void _broadcastTaskHidden() {
    // TODO
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void __assertThisXTask(XTask thisXTask) {
    if (thisXTask.task != this || thisXTask.name != name) {
      throw "Error Assert task: ${thisXTask.task} - $this";
    }
  }
}
