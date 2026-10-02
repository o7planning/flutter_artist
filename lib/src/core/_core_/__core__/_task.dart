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
    FORM_OUTPUT> implements FormHost {
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
    required INIT_DATA? initData,
    required Map<String, dynamic>? formData,
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
      codeId: "#90100",
      shortDesc:
          "${debugObjHtml(this)} -> Begin ${executionUnitType.asDebugExecutionUnit()} (Load InitData)",
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
        codeId: "#90120",
        caller: this,
        methodName: "performLoadInitData",
        suffixShortDesc: "",
      );
      debug._performLoadInitDataCount++;

      final ApiResult<INIT_DATA> result = await performLoadInitData();
      result.throwIfError();

      _initData = result.data;
      _dataState = const TaskDataStateLoadedFresh();

      // =======================================================================
      // FORM MODEL LIFECYCLE COORDINATION (Transition from none to pending)
      // =======================================================================
      if (formModel != null) {
        executionTrace.addInfo(
          codeId: "#90135",
          shortDesc:
              "INIT_DATA loaded successfully -> Transitioning FormModel state to pending.",
        );

        final newFormDataState = FormDataStateUtils.calculateNewLazyDataState(
          currentFormDataState: formModel!.dataState,
          hasCurrentItem: _initData != null,
          currentItemChanged: true,
        );

        formModel!._formModelStructure._setFormDataState(
          formDataState: newFormDataState,
          error: null,
        );
      }

      executionTrace.addInfo(
        codeId: "#90140",
        shortDesc:
            "${debugObjHtml(this)} -> Successfully loaded INIT_DATA: ${debugObjHtml(_initData)}.",
      );
    } catch (e, stackTrace) {
      taskErrorInfo = TaskErrorInfo(
        taskErrorMethod: TaskErrorMethod.performLoadInitData,
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

      // Transition to failed state preserving error info
      if (_initData != null) {
        _dataState = TaskDataStateLoadedStale(staleErrorInfo: taskErrorInfo);
      } else {
        _dataState = TaskDataStatePending.failed(errorInfo: taskErrorInfo);
      }

      executionTrace.addInfo(
        codeId: "#90160",
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
    required XTask<INIT_DATA, RESULT_DATA, FORM_INPUT, FORM_OUTPUT> thisXTask,
    required TaskSubmitIntent<INIT_DATA, RESULT_DATA> executionIntent,
  }) async {
    // Handled in subsequent phase
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

  /// Evaluates whether this Task permits submitting its current state.
  @_PrecheckMethod()
  Actionable<TaskSubmitPrecheck> canSubmit() {
    // 1. Check if the global executor is busy processing another operation
    if (FlutterArtist.executor.isBusy) {
      return Actionable<TaskSubmitPrecheck>.no(
          errCode: TaskSubmitPrecheck.busy);
    }

    // 2. Check if the task is still in a pending state (initialization data not yet loaded)
    if (dataState.isPending) {
      return Actionable<TaskSubmitPrecheck>.no(
          errCode: TaskSubmitPrecheck.taskInPendingState);
    }

    // 3. Check Form constraints (Only evaluated if the Task declares a formModel)
    if (formModel != null) {
      // if (!formModel!.formInitialDataReady) {
      //   return Actionable<TaskSubmitPrecheck>.no(errCode: TaskSubmitPrecheck.formInitialDataNotReady);
      // }
      //
      // // Validate all active form builder states currently mounted in the UI
      // final activeForms = formModel!.ui._visibleFormBuilderStates;
      // bool allFormsAreValid = true;
      // for (FormBuilderState formState in activeForms) {
      //   bool isValid = formState.validate(focusOnInvalid: false);
      //   allFormsAreValid = allFormsAreValid && isValid;
      // }
      //
      // if (!allFormsAreValid) {
      //   return Actionable<TaskSubmitPrecheck>.no(errCode: TaskSubmitPrecheck.formInvalidated);
      // }
    }

    return Actionable<TaskSubmitPrecheck>.yes();
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
    Actionable<TaskSubmitPrecheck> actionable = canSubmit();

    if (!actionable.yes) {
      _addErrorLogActionable(
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

    final TaskSubmitIntent<INIT_DATA, RESULT_DATA> executionIntent =
        xTask._createAndSetTaskIntentSubmit();

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

  @_PrecheckMethod()
  Actionable<ShowFormInfoPrecheck> canShowFormInfo() {
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
