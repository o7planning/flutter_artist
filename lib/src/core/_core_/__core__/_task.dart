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
    FORM_OUTPUT>
    implements FormHost {
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
  // ABSTRACT CONTRACTS
  // ===========================================================================

  /// Asynchronously fetches baseline metadata/context required for this Task.
  ///
  /// Symmetric to [performQuery] in Scalar and [performLoadItemDetailById] in Block.
  @_AbstractMethodAnnotation()
  Future<ApiResult<INIT_DATA>> performLoadInitData();

  /// Executes the core submission logic of the Task with user input.
  @_AbstractMethodAnnotation()
  Future<ApiResult<RESULT_DATA>> performSubmit({
    required INIT_DATA initData,
    required FORM_OUTPUT? formData,
  });

  // ===========================================================================
  // EXECUTION UNIT: _unitLoadInitData
  // ===========================================================================

  /// Internal ExecutionUnit method handling asynchronous INIT_DATA retrieval.
  ///
  /// Invoked by [_TaskLoadInitDataExcutionUnit].
  @_ExecutionUnitMethodAnnotation()
  Future<void> _unitLoadInitData({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XTask thisXTask,
    required TaskLoadInitDataIntent<INIT_DATA, RESULT_DATA> executionIntent,
  }) async {
    __assertThisXTask(thisXTask);
    thisXTask._createAndSetTaskIntentDone(
      lastIntentInfo: "Load Init Data",
    );

    final ExecHint initialExecHint = thisXTask.execHint;
    thisXTask.resetExecutionHints();

    executionTrace.addInfo(
      codeId: "#090100",
      shortDesc:
      "${debugObjHtml(this)} -> Begin ${executionUnitType
          .asDebugExecutionUnit()} (Load InitData)",
    );

    final executionResult = executionIntent.resultWrapper._setResult(
      TaskLoadInitDataResult<INIT_DATA, RESULT_DATA>(precheck: null),
      objectCaller: this,
      methodName: '_unitLoadInitData',
    );

    TaskErrorInfo? taskErrorInfo;
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

      _initData = result.data;
      _dataState = const TaskDataStateLoadedFresh();

      executionTrace.addInfo(
        codeId: "#090240",
        shortDesc: "INIT_DATA loaded successfully.",
        parameters: {
          "initData": _initData,
          "dataState": _dataState,
        },
      );

      // =======================================================================
      // FORM MODEL LIFECYCLE COORDINATION (Transition from none to pending)
      // =======================================================================
      if (formModel != null) {
        final newFormDataState =
        TaskFormDataStateUtils.calculateNewLazyDataState(
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

      // Transition to failed state preserving error info
      if (_initData != null) {
        _dataState = TaskDataStateLoadedStale(staleErrorInfo: taskErrorInfo);
      } else {
        _dataState = TaskDataStatePending.failed(errorInfo: taskErrorInfo);
      }
      // 🛑 Form Data State
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
      "${debugObjHtml(this)} -> Begin ${executionUnitType
          .asDebugExecutionUnit()} (Submit)",
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
      _dataState = TaskDataStateSubmissionAttemptedFailed(
        submissionErrorInfo: taskErrorInfo,
      );
      return;
    }
    try {
      ApiResult<RESULT_DATA> result = await performSubmit(
        initData: initData!,
        formData: formOutput,
      );
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
      TaskErrorInfo taskErrorInfo = TaskErrorInfo(
        taskErrorMethod: TaskErrorMethod.performSubmit,
        error: e,
        errorStackTrace: stackTrace,
      );
      _dataState = TaskDataStateSubmissionAttemptedFailed(
        submissionErrorInfo: taskErrorInfo,
      );
      return;
    }
    _dataState = TaskDataStateSubmissionAttemptedSuccess();
  }

  // ===========================================================================
  // PUBLIC CONTROLS
  // ===========================================================================

  /// Triggers asynchronous loading of [INIT_DATA] through the framework queue.
  Future<TaskLoadInitDataResult<INIT_DATA, RESULT_DATA>> loadInitData() async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "loadInitData",
      parameters: null,
      isLibMethod: true,
    );

    final XActivity xActivity = _XActivityTaskLoadInitData(task: this);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xActivity);
    await FlutterArtist.executor._executeExecutionUnitQueue();

    final thisXTask = xActivity.findXTaskByName(name) as XTask<
        INIT_DATA, //
        RESULT_DATA,
        FORM_INPUT,
        FORM_OUTPUT>;
    return thisXTask.loadInitDataResult;
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
      checkAllow: checkAllow,
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
  // ***************************************************************************

  bool isPendingOrStale({required bool requiresVisible}) {
    final bool visible = ui.hasVisibleViews();
    if (requiresVisible && !visible) {
      return false;
    }
    return dataState.isPending || dataState.isStale;
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
    if (dataState.isPending || dataState.isStale) {
      return false;
    } else if (dataState.isFresh ||
        dataState.isSubmissionAttemptedSuccess ||
        dataState.isSubmissionAttemptedFailed) {
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
    if (formModel == null) {
      return Actionable<TaskFormEnablePrecheck>.no(
        errCode: TaskFormEnablePrecheck.noForm,
      );
    }
    if (!isStateReadyForForm()) {
      return Actionable<TaskFormEnablePrecheck>.no(
        errCode: TaskFormEnablePrecheck.noForm,
      );
    }
    final FormDataState formDataState = formModel!.dataState;

    if (formDataState.isNone) {
      return Actionable<TaskFormEnablePrecheck>.no(
        errCode: TaskFormEnablePrecheck.formInNoneState,
      );
    } else if (formDataState.isPending) {
      return Actionable<TaskFormEnablePrecheck>.no(
        errCode: TaskFormEnablePrecheck.formInPendingState,
      );
    } else if (formDataState.isFatalError) {
      return Actionable<TaskFormEnablePrecheck>.no(
        errCode: TaskFormEnablePrecheck.formInFatalErrorState,
      );
    } else if (formDataState.isStale) {
      return Actionable<TaskFormEnablePrecheck>.no(
        errCode: TaskFormEnablePrecheck.formInStaleState,
      );
    }
    return Actionable<TaskFormEnablePrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<ShowFormInfoPrecheck> checkBeforeShowFormInfo() {
    return _internalCanShowFormInfo(formModel: formModel);
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void _broadcastScalarHidden() {
    switch (effectiveConfig.onHideAction) {
      case ScalarHiddenAction.none:
        break;
      case ScalarHiddenAction.clear:
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
