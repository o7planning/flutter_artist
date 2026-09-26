part of '../core.dart';

abstract class Task<
    TASK_DATA extends TaskData, //
    CREATION_PRESET extends CreationPreset,
    FORM_INPUT extends FormInput> extends _Core {
  final String name;
  final TaskConfig config;
  final TaskEffectiveConfig effectiveConfig;

  late final Activity activity;

  final TaskFormModel<
      TASK_DATA, //
      CREATION_PRESET,
      FORM_INPUT,
      AdditionalFormRelatedData>? formModel;

  late final ui = _TaskUiComponents(task: this);

  TaskDataState _dataState = TaskDataStatePending();

  TaskDataState get dataState => _dataState;

  void _setTaskDataState(TaskDataState dataState) {
    _dataState = dataState;
  }

  Task({
    required this.name,
    this.config = const TaskConfig(),
    this.formModel,
  }) : effectiveConfig = TaskEffectiveConfig.fromConfig(config) {
    formModel?._bindToTask(this);
  }

  // ***************************************************************************

  XTask<TASK_DATA, CREATION_PRESET, FORM_INPUT> _createXTask({
    required XActivity xActivity,
  }) {
    return XTask<TASK_DATA, CREATION_PRESET, FORM_INPUT>._(
      task: this,
      xActivity: xActivity,
    );
  }

  // ***************************************************************************

  void _bindToActivity(Activity parentActivity) {
    activity = parentActivity;
  }

  bool get hasForm => formModel != null;

  bool get hasError => false;

  // ***************************************************************************
  // ***************************************************************************

  Future<void> execute() async {
    //
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _unitTaskExecution({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XTask<
            TASK_DATA, //
            CREATION_PRESET,
            FORM_INPUT>
        thisXTask,
    required TaskExecutionIntent<TaskData> executionIntent,
  }) async {
    __assertThisXTask(thisXTask);

    final ExecHint initialExecHint = thisXTask.execHint;

    thisXTask._setExecutedTrue();
    thisXTask._createAndSetTaskIntentDone(lastIntentInfo: "Execute");
    thisXTask.resetExecutionHints();
    //
    executionTrace.addInfo(
      codeId: "#90000",
      shortDesc:
          "${debugObjHtml(this)} -> Begin ${executionUnitType.asDebugExecutionUnit()}",
    );

    final executionResult = executionIntent.resultWrapper._setResult(
      TaskExecutionResult<TASK_DATA>(precheck: null),
      objectCaller: this,
      methodName: '_unitTaskExecution',
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<ApiResult<TASK_DATA>> performExecute({
    required Map<String, dynamic>? formData,
  });

  Future<void> _processTaskSubmitResult(ApiResult<TASK_DATA> apiResult) async {
    // ...
  }

  void showTaskErrorViewerDialog(BuildContext context) {
    // ...
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void __assertThisXTask(XTask thisXTask) {
    if (thisXTask.task != this || thisXTask.name != name) {
      String message = "Error Assert task: ${thisXTask.task} - $this";
      print("FATAL ERROR: $message");
      throw message;
    }
  }
}
