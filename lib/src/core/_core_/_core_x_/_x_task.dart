part of '../core.dart';

/// Runtime execution wrapper for [Task], managing intent delegation,
/// single-stage progress lifecycle, and state mutation.
class XTask<
TASK_INIT_DATA extends TaskInitData, //
TASK_RESULT_DATA extends TaskResultData,
FORM_INPUT extends FormInput,
FORM_OUTPUT extends FormOutput> {
  final XActivity xActivity;

  final XTaskFormModel? xTaskFormModel;

  final Task<
      TASK_INIT_DATA, //
      TASK_RESULT_DATA,
      FORM_INPUT,
      FORM_OUTPUT> task;

  bool _executed = false;

  bool get executed => _executed;

  String get name => task.name;

  int get xModuleId => xActivity.xModuleId;

  ExecHint _execHint = ExecHint.none;

  ExecHint get execHint => _execHint;

  TaskBaseExecutionIntent<
      TASK_INIT_DATA, //
      TASK_RESULT_DATA,
      dynamic,
      ExecutionUnitResult<dynamic>>? _stashedIntent;

  TaskBaseExecutionIntent<
      TASK_INIT_DATA, //
      TASK_RESULT_DATA,
      dynamic,
      ExecutionUnitResult<dynamic>>? _executionIntent;

  TaskBaseExecutionIntent<TASK_INIT_DATA, TASK_RESULT_DATA, dynamic, dynamic>?
  get executionIntent => _executionIntent;

  XTask._({
    required this.xActivity,
    required this.task,
    required this.xTaskFormModel,
  });

  final restartResult =
  TaskRestartResult<TASK_INIT_DATA, TASK_RESULT_DATA>(precheck: null);

  void setExecHint(ExecHint hint) {
    _execHint = hint;
  }

  void setExecHintToGreater(ExecHint hint) {
    if (_execHint.isLessThan(hint)) {
      _execHint = hint;
    }
  }

  void resetExecutionHints() {
    _execHint = ExecHint.none;
  }

  void _setExecutedTrue() {
    _executed = true;
  }

  void _setExecutedFalse() {
    _executed = false;
  }

  // ***************************************************************************
  // ***************************************************************************

  NxtExecutionUnit _getNextExecutionUnit({required bool debug}) {
    NxtExecutionUnit next = __getNextExecutionUnit(debug: debug);
    if (next.yes) {
      return next;
    }
    if (xTaskFormModel != null) {
      next = xTaskFormModel!._getNextExecutionUnit(debug: debug);
      if (next.yes) {
        return next;
      }
    }
    return next;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Evaluates and yields the next operational execution unit for this Task.
  NxtExecutionUnit __getNextExecutionUnit({required bool debug}) {
    // 1. Restore the stashed intent if the current intent is empty
    if (_executionIntent == null && _stashedIntent != null) {
      _executionIntent = _stashedIntent;
      _stashedIntent = null;
    }

    final input = TaskNextUnitInput(
      dataState: task.dataState,
      currentIntent: _executionIntent,
      execHint: _execHint,
      isVisible: task.ui.hasVisibleViews(),
      executed: _executed,
      modelName: getClassNameWithoutGenerics(task),
    );

    final output = TaskExecutionCalculator.calculate(input);

    // 2. Retain the old Intent if necessary
    if (output.preserveCurrentIntent) {
      _stashedIntent = _executionIntent;
    }

    String finalDebugInfo = output.debugInfo;

    // 3. Inject the Missing Intent (if applicable) and update the Debug info to match the original version.
    if (output.missingIntent == MissingIntentType.restart) {
      final intentToUse = _createAndSetTaskIntentRestart();
      finalDebugInfo = finalDebugInfo.replaceFirst(
          "_executionIntent: $_stashedIntent",
          "_executionIntent: $_stashedIntent --> $intentToUse");
    }

    // 4. Return to Execution Unit
    switch (output.action) {
      case TaskExecutionAction.restart:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _TaskRestartExecutionUnit<TASK_INIT_DATA,
              TASK_RESULT_DATA,
              FORM_INPUT>(
            xTask: this,
            executionIntent: _executionIntent
            as TaskRestartIntent<TASK_INIT_DATA, TASK_RESULT_DATA>,
          ),
          info: finalDebugInfo,
        );
      case TaskExecutionAction.submit:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _TaskSubmitExecutionUnit<TASK_INIT_DATA,
              TASK_RESULT_DATA,
              FORM_INPUT,
              FORM_OUTPUT>(
            xTask: this,
            executionIntent: _executionIntent as TaskSubmitIntent<
                TASK_INIT_DATA,
                TASK_RESULT_DATA,
                FORM_OUTPUT>,
          ),
          info: finalDebugInfo,
        );
      case TaskExecutionAction.none:
      default:
        return NxtExecutionUnit.no(
          debug: debug,
          info: finalDebugInfo,
        );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _createAndSetTaskIntentDone({required String lastIntentInfo}) {
    _executionIntent = TaskDoneIntent(
      lastIntentInfo: lastIntentInfo,
    );
  }

  TaskSubmitIntent<TASK_INIT_DATA, TASK_RESULT_DATA, FORM_OUTPUT>
  _createAndSetTaskIntentSubmit() {
    final executionIntent =
    TaskSubmitIntent<TASK_INIT_DATA, TASK_RESULT_DATA, FORM_OUTPUT>();
    _executionIntent = executionIntent;
    return executionIntent;
  }

  TaskRestartIntent<TASK_INIT_DATA, TASK_RESULT_DATA>
  _createAndSetTaskIntentRestart() {
    final executionIntent =
    TaskRestartIntent<TASK_INIT_DATA, TASK_RESULT_DATA>();
    _executionIntent = executionIntent;
    return executionIntent;
  }
}
