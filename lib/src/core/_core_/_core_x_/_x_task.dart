part of '../core.dart';

/// Runtime execution wrapper for [Task], managing intent delegation,
/// single-stage progress lifecycle, and state mutation.
class XTask<
    TASK_INIT_DATA extends TaskInitData,
    TASK_RESULT_DATA extends TaskResultData, //\
    FORM_INPUT extends FormInput> {
  final XActivity xActivity;

  final XTaskFormModel? xTaskFormModel;

  final Task<
      TASK_INIT_DATA, //
      TASK_RESULT_DATA,
      FORM_INPUT> task;

  bool _executed = false;

  bool get executed => _executed;

  String get name => task.name;

  int get xModuleId => xActivity.xModuleId;

  ExecHint _execHint = ExecHint.none;

  ExecHint get execHint => _execHint;

  TaskBaseExecutionIntent<TASK_INIT_DATA, TASK_RESULT_DATA, dynamic, dynamic>?
      _executionIntent;

  TaskBaseExecutionIntent<TASK_INIT_DATA, TASK_RESULT_DATA, dynamic, dynamic>?
      get executionIntent => _executionIntent;

  XTask._({
    required this.xActivity,
    required this.task,
    required this.xTaskFormModel,
  });

  TaskLoadInitDataResult<TASK_INIT_DATA> loadInitDataResult =
      TaskLoadInitDataResult<TASK_INIT_DATA>(precheck: null);

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
    final TaskDataState taskDataState = task.dataState;
    final executionIntent = _executionIntent;
    final bool isVisible = task.ui.hasVisibleViews();

    // =========================================================================
    // 1. DATA STATE = PENDING
    // =========================================================================
    if (taskDataState.isPending) {
      final bool shouldExecute =
          (_execHint == ExecHint.force || isVisible) && !_executed;

      if (shouldExecute) {
        final TaskLoadInitDataIntent<TASK_INIT_DATA, TASK_RESULT_DATA>
            intentToUse;
        if (executionIntent
            is TaskLoadInitDataIntent<TASK_INIT_DATA, TASK_RESULT_DATA>) {
          intentToUse = executionIntent;
        } else {
          intentToUse = _createAndSetTaskIntentLoadInitData();
        }
        // IN: DATA STATE = PENDING
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _TaskLoadInitDataExecutionUnit<
              TASK_INIT_DATA, //
              TASK_RESULT_DATA,
              FORM_INPUT>(
            xTask: this,
            executionIntent: intentToUse,
          ),
          info:
              "Task (1.1), ${getClassNameWithoutGenerics(task)}, _executionIntent: $executionIntent --> $intentToUse, "
              "dataState: ${taskDataState.toBriefInfo()}, execHint: $_execHint, isVisible: $isVisible",
        );
      } else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
              "Task (1.2), ${getClassNameWithoutGenerics(task)}, _executionIntent: $executionIntent, "
              "dataState: ${taskDataState.toBriefInfo()}, execHint: $_execHint, isVisible: $isVisible",
        );
      }
    }

    // =========================================================================
    // 2. DATA STATE = STALE
    // =========================================================================
    else if (taskDataState.isStale) {
      final bool shouldExecute =
          (_execHint == ExecHint.force || isVisible) && !_executed;

      if (shouldExecute) {
        final TaskSubmitIntent<TASK_INIT_DATA, TASK_RESULT_DATA> intentToUse;
        if (executionIntent
            is TaskSubmitIntent<TASK_INIT_DATA, TASK_RESULT_DATA>) {
          intentToUse = executionIntent;
        } else {
          intentToUse = _createAndSetTaskIntentSubmit();
        }

        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _TaskSubmitExecutionUnit(
            xTask: this,
            executionIntent: intentToUse,
          ),
          info:
              "Task (2.1), ${getClassNameWithoutGenerics(task)}, _executionIntent: $executionIntent --> $intentToUse, "
              "dataState: ${taskDataState.toBriefInfo()}, execHint: $_execHint, isVisible: $isVisible",
        );
      } else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
              "Task (2.2), ${getClassNameWithoutGenerics(task)}, _executionIntent: $executionIntent, "
              "dataState: ${taskDataState.toBriefInfo()}, execHint: $_execHint, isVisible: $isVisible",
        );
      }
    }

    // =========================================================================
    // 3. DATA STATE = FRESH
    // =========================================================================
    else if (taskDataState.isFresh) {
      // IN: DATA STATE = FRESH
      // 3.0. Intercept terminal Done intent to prevent duplicate scheduler cycles
      if (executionIntent is TaskDoneIntent) {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
              "Task (3.0), ${getClassNameWithoutGenerics(task)}, _executionIntent: $executionIntent, "
              "dataState: ${taskDataState.toBriefInfo()}",
        );
      }
      // IN: DATA STATE = FRESH
      // 3.1. Force execution explicitly requested via ExecHint
      if (_execHint == ExecHint.force) {
        final TaskLoadInitDataIntent<TASK_INIT_DATA, TASK_RESULT_DATA>
            intentToUse;
        if (executionIntent
            is TaskLoadInitDataIntent<TASK_INIT_DATA, TASK_RESULT_DATA>) {
          intentToUse = executionIntent;
        } else {
          intentToUse = _createAndSetTaskIntentLoadInitData();
        }

        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _TaskLoadInitDataExecutionUnit(
            xTask: this,
            executionIntent: intentToUse,
          ),
          info:
              "Task (3.1), ${getClassNameWithoutGenerics(task)}, _executionIntent: $intentToUse, "
              "dataState: ${taskDataState.toBriefInfo()}, execHint: $_execHint, isVisible: $isVisible",
        );
      }
      // IN: DATA STATE = FRESH
      // 3.2. Handle active execution intents dispatched imperatively
      if (executionIntent != null) {
        if (executionIntent is TaskNullIntent) {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
                "Task (3.2.1), ${getClassNameWithoutGenerics(task)}, _executionIntent: $executionIntent, "
                "dataState: ${taskDataState.toBriefInfo()}",
          );
        }
        // TaskSubmitIntent
        else if (executionIntent
            is TaskSubmitIntent<TASK_INIT_DATA, TASK_RESULT_DATA>) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _TaskSubmitExecutionUnit(
              xTask: this,
              executionIntent: executionIntent,
            ),
            info:
                "Task (3.2.2), ${getClassNameWithoutGenerics(task)}, _executionIntent: $executionIntent, "
                "dataState: ${taskDataState.toBriefInfo()}",
          );
        } else {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
                "Task (3.2.3), ${getClassNameWithoutGenerics(task)}, unhandled _executionIntent: $executionIntent, "
                "dataState: ${taskDataState.toBriefInfo()}",
          );
        }
      }
      // IN: DATA STATE = FRESH
      // 3.3. Idle state when data is fresh and no intent is active
      return NxtExecutionUnit.no(
        debug: debug,
        info:
            "Task (3.3), ${getClassNameWithoutGenerics(task)}, _executionIntent: null, "
            "dataState: ${taskDataState.toBriefInfo()}, execHint: $_execHint, isVisible: $isVisible",
      );
    }

    // =========================================================================
    // 4. UNHANDLED / FALLTHROUGH STATE
    // =========================================================================
    return NxtExecutionUnit.no(
      debug: debug,
      info:
          "Task (4.1), ${getClassNameWithoutGenerics(task)}, _executionIntent: $executionIntent, "
          "dataState: ${taskDataState.toBriefInfo()}, isVisible: $isVisible",
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _createAndSetTaskIntentDone({required String lastIntentInfo}) {
    _executionIntent = TaskDoneIntent<TASK_INIT_DATA, TASK_RESULT_DATA>(
      lastIntentInfo: lastIntentInfo,
    );
  }

  TaskSubmitIntent<TASK_INIT_DATA, TASK_RESULT_DATA>
      _createAndSetTaskIntentSubmit() {
    final executionIntent =
        TaskSubmitIntent<TASK_INIT_DATA, TASK_RESULT_DATA>();
    _executionIntent = executionIntent;
    return executionIntent;
  }

  TaskLoadInitDataIntent<TASK_INIT_DATA, TASK_RESULT_DATA>
      _createAndSetTaskIntentLoadInitData() {
    final executionIntent =
        TaskLoadInitDataIntent<TASK_INIT_DATA, TASK_RESULT_DATA>();
    _executionIntent = executionIntent;
    return executionIntent;
  }
}
