part of '../core.dart';

/// Represents a standalone transactional unit of work within an Activity.
///
/// Lifecycle:
/// [TaskDataStatePending] -> (loads INIT_DATA) -> [TaskDataStateLoadedFresh]
/// -> (submission) -> [TaskDataStateSubmissionAttempted]
abstract class Task<
    INIT_DATA extends TaskInitData, //
    RESULT_DATA extends TaskResultData, //
    FORM_INPUT extends FormInput> extends _Core implements FormHost {
  final String name;
  final String? description;
  final TaskConfig config;
  final TaskEffectiveConfig effectiveConfig;

  late final debug = _TaskDebugInfo(task: this);

  late final Activity activity;

  Activity get module => activity;

  late final ui = _TaskUiComponents(task: this);

  @override
  TaskFormModel<
      INIT_DATA, //
      RESULT_DATA,
      FORM_INPUT,
      AdditionalFormRelatedData>? formModel;

  // ===========================================================================
  // EMBEDDED TASK STATE STORAGE
  // ===========================================================================

  TaskDataState _dataState = const TaskDataStatePending.initial();

  TaskDataState get dataState => _dataState;

  INIT_DATA? _initData;

  INIT_DATA? get initData => _initData;

  RESULT_DATA? _lastResultData;

  RESULT_DATA? get lastResultData => _lastResultData;

  bool __isLoadingInitData = false;

  bool get isLoadingInitData => __isLoadingInitData;

  bool __isExecuting = false;

  bool get isExecuting => __isExecuting;

  bool get hasForm => formModel != null;

  bool get hasError => _dataState.hasError;

  TaskErrorInfo? get errorInfo => _dataState.errorInfo;

  // ===========================================================================
  // Constructor
  // ===========================================================================

  Task({
    required this.name,
    this.description,
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
        FORM_INPUT>._(
      xActivity: xActivity,
      task: this,
      xTaskFormModel: xTaskFormModel,
    );
  }

  // ===========================================================================

  void _bindToActivity(Activity parentActivity) {
    activity = parentActivity;
  }

  // ===========================================================================
  // GENERICS TYPES:
  // ===========================================================================

  Type getInitDataType() => INIT_DATA;

  Type getResultDataType() => RESULT_DATA;

  Type getFormInputType() => FORM_INPUT;

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

    final ExecHint initialExecHint = thisXTask.execHint;
    thisXTask.resetExecutionHints();

    executionTrace.addInfo(
      codeId: "#90100",
      shortDesc:
          "${debugObjHtml(this)} -> Begin ${executionUnitType.asDebugExecutionUnit()} (Load InitData)",
    );

    final executionResult = executionIntent.resultWrapper._setResult(
      TaskLoadInitDataResult<INIT_DATA>(precheck: null),
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
    required XTask<TaskInitData, TaskResultData, FormInput> thisXTask,
    required TaskSubmitIntent<TaskInitData, TaskResultData> executionIntent,
  }) async {
    // Handled in subsequent phase
  }

  // ===========================================================================
  // PUBLIC CONTROLS
  // ===========================================================================

  /// Triggers asynchronous loading of [INIT_DATA] through the framework queue.
  Future<TaskLoadInitDataResult<INIT_DATA>> loadInitData() async {
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
        FORM_INPUT>;
    return thisXTask.loadInitDataResult;
  }

  bool isPendingOrStale({required bool requiresVisible}) {
    final bool visible = ui.hasVisibleViews();
    if (requiresVisible && !visible) {
      return false;
    }
    return dataState.isPending || dataState.isStale;
  }

  /// Resets the Task back to cold initial pending state.
  void clear() {
    _initData = null;
    _lastResultData = null;
    _dataState = const TaskDataStatePending.initial();
  }

  void __refreshLoadingInitDataState({required bool isLoading}) {
    try {
      __isLoadingInitData = isLoading;
      ui.refreshControlBars();
    } catch (_) {}
  }

  void showTaskErrorViewerDialog(BuildContext context) {
    if (errorInfo != null) {
      ErrorViewerDialog.show(
        context: context,
        errorInfo: errorInfo!.toErrorInfo(),
      );
    }
  }

  Future<void> submit() async {
    // TODO:
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
