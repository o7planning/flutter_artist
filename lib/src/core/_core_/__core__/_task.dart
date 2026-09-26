part of '../core.dart';

abstract class Task<
    INIT_DATA extends TaskInitData,
    RESULT_DATA extends TaskResultData,
    CREATION_PRESET extends CreationPreset,
    FORM_INPUT extends FormInput> extends _Core {
  final String name;
  final TaskConfig config;
  final TaskEffectiveConfig effectiveConfig;

  late final Activity activity;

  final TaskFormModel<INIT_DATA, RESULT_DATA, CREATION_PRESET, FORM_INPUT,
      AdditionalFormRelatedData>? formModel;

  late final ui = _TaskUiComponents(task: this);

  TaskDataState _dataState = TaskDataStatePending();
  TaskDataState get dataState => _dataState;

  INIT_DATA? _initData;
  INIT_DATA? get initData => _initData;

  RESULT_DATA? _lastResultData;
  RESULT_DATA? get lastResultData => _lastResultData;

  Task({
    required this.name,
    this.config = const TaskConfig(),
    this.formModel,
  }) : effectiveConfig = TaskEffectiveConfig.fromConfig(config) {
    formModel?._bindToTask(this);
  }

  void _bindToActivity(Activity parentActivity) {
    activity = parentActivity;
  }

  bool get hasForm => formModel != null;
  bool get hasError => _dataState.hasError;

  // ===========================================================================
  // ABSTRACT METHODS
  // ===========================================================================

  /// Asynchronously loads baseline context/metadata required before opening the Task Form.
  ///
  /// Equivalent to [performLoadItemDetailById] in Block.
  @_AbstractMethodAnnotation()
  Future<ApiResult<INIT_DATA>> performLoadTaskInitData();

  /// Executes the core operation of this Task and yields a result.
  @_AbstractMethodAnnotation()
  Future<ApiResult<RESULT_DATA>> performExecute({
    required Map<String, dynamic>? formData,
    required INIT_DATA? initData,
  });

  /// Builds synchronous in-memory presets for the task form.
  @_AbstractMethodAnnotation()
  CREATION_PRESET buildCreationPreset();

  /// Fallback hook to build a default [FORM_INPUT] if none was explicitly passed.
  @_AbstractMethodAnnotation()
  FORM_INPUT buildFormInput();

  // ===========================================================================
  // EXECUTION CORE
  // ===========================================================================

  /// Public entry to trigger task execution programmatically.
  Future<TaskSubmitExecutionResult<RESULT_DATA>> execute({
    FORM_INPUT? formInput,
  }) async {
    // Triggers execution queue through root queue & executor
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "execute",
      parameters: {"formInput": formInput},
      isLibMethod: true,
    );

    final XShelf xShelf = _XShelfTaskExecution(
      task: this,
      formInput: formInput,
    );

    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();

    final XTask thisXTask = xShelf.findXTaskByName(name)!;
    return thisXTask.executionResult as TaskSubmitExecutionResult<RESULT_DATA>;
  }

  /// Internal ExecutionUnit method handling data loading and submission.
  Future<void> _unitTaskExecution({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XTask<INIT_DATA, RESULT_DATA, CREATION_PRESET, FORM_INPUT>
        thisXTask,
    required TaskSubmitIntent<INIT_DATA, RESULT_DATA> executionIntent,
  }) async {
    __assertThisXTask(thisXTask);

    executionTrace.addInfo(
      codeId: "#90000",
      shortDesc:
          "${debugObjHtml(this)} -> Begin ${executionUnitType.asDebugExecutionUnit()}",
    );

    final executionResult = executionIntent.resultWrapper._setResult(
      TaskSubmitExecutionResult<RESULT_DATA>(precheck: null),
      objectCaller: this,
      methodName: '_unitTaskExecution',
    );

    // 1. Load Task Init Data if not already loaded or force requested
    if (_initData == null) {
      try {
        final ApiResult<INIT_DATA> initResult = await performLoadTaskInitData();
        initResult.throwIfError();
        _initData = initResult.data;
      } catch (e, stackTrace) {
        final errorInfo = _handleError(
          shelf: null,
          methodName: "performLoadTaskInitData",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
          tipDocument: null,
        );
        executionResult._setErrorInfo(errorInfo: errorInfo);
        _dataState = TaskDataStateFailed(errorInfo: errorInfo);
        return;
      }
    }

    // 2. Execute Task submission
    try {
      final Map<String, dynamic>? formData = formModel?.currentFormData;
      final ApiResult<RESULT_DATA> result = await performExecute(
        formData: formData,
        initData: _initData,
      );
      result.throwIfError();

      _lastResultData = result.data;
      _dataState = const TaskDataStateCompleted();
      executionResult._setData(result.data);
    } catch (e, stackTrace) {
      final errorInfo = _handleError(
        shelf: null,
        methodName: "performExecute",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      executionResult._setErrorInfo(errorInfo: errorInfo);
      _dataState = TaskDataStateFailed(errorInfo: errorInfo);
    }
  }

  void showTaskErrorViewerDialog(BuildContext context) {
    if (_dataState.errorInfo != null) {
      ErrorViewerDialog.show(
        context: context,
        errorInfo: _dataState.errorInfo!,
      );
    }
  }

  void __assertThisXTask(XTask thisXTask) {
    if (thisXTask.task != this || thisXTask.name != name) {
      throw "Error Assert task: ${thisXTask.task} - $this";
    }
  }
}
