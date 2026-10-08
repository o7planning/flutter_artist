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

  TaskBaseExecutionIntent<TASK_INIT_DATA, TASK_RESULT_DATA, dynamic, dynamic>?
      _executionIntent;

  TaskBaseExecutionIntent<TASK_INIT_DATA, TASK_RESULT_DATA, dynamic, dynamic>?
      get executionIntent => _executionIntent;

  XTask._({
    required this.xActivity,
    required this.task,
    required this.xTaskFormModel,
  });

  final loadInitDataResult =
      TaskLoadInitDataResult<TASK_INIT_DATA, TASK_RESULT_DATA>(precheck: null);

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
    final originExecutionIntent = _executionIntent;
    final bool isVisible = task.ui.hasVisibleViews();

    if (originExecutionIntent is TaskDoneIntent) {
      return NxtExecutionUnit.no(
        debug: debug,
        info:
            "Task (0.0), ${getClassNameWithoutGenerics(task)}, _executionIntent: $originExecutionIntent, "
            "dataState: ${taskDataState.toBriefInfo()}, execHint: $_execHint, isVisible: $isVisible",
      );
    }

    // =========================================================================
    // 1. DATA STATE = PENDING
    // =========================================================================
    if (taskDataState.isPending) {
      final bool shouldExecute =
          (_execHint == ExecHint.force || isVisible) && !_executed;

      if (shouldExecute) {
        final TaskLoadInitDataIntent<TASK_INIT_DATA, TASK_RESULT_DATA>
            intentToUse;
        if (originExecutionIntent
            is TaskLoadInitDataIntent<TASK_INIT_DATA, TASK_RESULT_DATA>) {
          intentToUse = originExecutionIntent;
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
              "Task (1.1), ${getClassNameWithoutGenerics(task)}, _executionIntent: $originExecutionIntent --> $intentToUse, "
              "dataState: ${taskDataState.toBriefInfo()}, execHint: $_execHint, isVisible: $isVisible",
        );
      } else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
              "Task (1.2), ${getClassNameWithoutGenerics(task)}, _executionIntent: $originExecutionIntent, "
              "dataState: ${taskDataState.toBriefInfo()}, execHint: $_execHint, isVisible: $isVisible",
        );
      }
    }

    // =========================================================================
    // 2. DATA STATE = STALE
    // =========================================================================
    else if (taskDataState.isStale) {
      final bool shouldExecute =
          (_execHint == ExecHint.force) && !_executed;

      if (shouldExecute) {
        final TaskLoadInitDataIntent<TASK_INIT_DATA, TASK_RESULT_DATA>
            intentToUse;
        if (originExecutionIntent
            is TaskLoadInitDataIntent<TASK_INIT_DATA, TASK_RESULT_DATA>) {
          intentToUse = originExecutionIntent;
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
              "Task (2.1), ${getClassNameWithoutGenerics(task)}, _executionIntent: $originExecutionIntent --> $intentToUse, "
              "dataState: ${taskDataState.toBriefInfo()}, execHint: $_execHint, isVisible: $isVisible",
        );
      } else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
              "Task (2.2), ${getClassNameWithoutGenerics(task)}, _executionIntent: $originExecutionIntent, "
              "dataState: ${taskDataState.toBriefInfo()}, execHint: $_execHint, isVisible: $isVisible",
        );
      }
    }

    // =========================================================================
    // 3. DATA STATE = FRESH
    // =========================================================================
    else if (taskDataState.isFresh) {
      // IN: DATA STATE = FRESH
      // 3.1. Force execution explicitly requested via ExecHint
      if (_execHint == ExecHint.force) {
        final TaskLoadInitDataIntent<TASK_INIT_DATA, TASK_RESULT_DATA>
            intentToUse;
        if (originExecutionIntent
            is TaskLoadInitDataIntent<TASK_INIT_DATA, TASK_RESULT_DATA>) {
          intentToUse = originExecutionIntent;
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
              "Task (3.1), ${getClassNameWithoutGenerics(task)}, _executionIntent: $originExecutionIntent --> $intentToUse, "
              "dataState: ${taskDataState.toBriefInfo()}, execHint: $_execHint, isVisible: $isVisible",
        );
      }
      // IN: DATA STATE = FRESH
      // 3.2. Handle active execution intents dispatched imperatively
      if (originExecutionIntent != null) {
        if (originExecutionIntent is TaskNullIntent) {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
                "Task (3.2.1), ${getClassNameWithoutGenerics(task)}, _executionIntent: $originExecutionIntent, "
                "dataState: ${taskDataState.toBriefInfo()}",
          );
        }
        // TaskSubmitIntent
        else if (originExecutionIntent is TaskSubmitIntent<TASK_INIT_DATA,
            TASK_RESULT_DATA, FORM_OUTPUT>) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _TaskSubmitExecutionUnit(
              xTask: this,
              executionIntent: originExecutionIntent,
            ),
            info:
                "Task (3.2.2), ${getClassNameWithoutGenerics(task)}, _executionIntent: $originExecutionIntent, "
                "dataState: ${taskDataState.toBriefInfo()}",
          );
        } else {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
                "Task (3.2.3), ${getClassNameWithoutGenerics(task)}, unhandled _executionIntent: $originExecutionIntent, "
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
    // 4. DATA STATE = SUBMISSION ATTEMPTED FAILED.
    // =========================================================================
    else if (taskDataState.isSubmissionAttemptedFailed) {
      final bool shouldReload =
          (_execHint == ExecHint.force || isVisible) && !_executed;

      if (shouldReload) {
        final TaskLoadInitDataIntent<TASK_INIT_DATA, TASK_RESULT_DATA>
            intentToUse;
        if (originExecutionIntent
            is TaskLoadInitDataIntent<TASK_INIT_DATA, TASK_RESULT_DATA>) {
          intentToUse = originExecutionIntent;
        } else {
          intentToUse = _createAndSetTaskIntentLoadInitData();
        }
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _TaskLoadInitDataExecutionUnit<TASK_INIT_DATA,
              TASK_RESULT_DATA, FORM_INPUT>(
            xTask: this,
            executionIntent: intentToUse,
          ),
          info:
              "Task (4.1), ${getClassNameWithoutGenerics(task)}, _executionIntent: $originExecutionIntent --> $intentToUse, "
              "dataState: ${taskDataState.toBriefInfo()}, execHint: $_execHint, isVisible: $isVisible",
        );
      }
      // !shouldReload
      else {
        if (originExecutionIntent != null) {
          if (originExecutionIntent is TaskNullIntent) {
            return NxtExecutionUnit.no(
              debug: debug,
              info:
                  "Task (4.2.1), ${getClassNameWithoutGenerics(task)}, _executionIntent: $originExecutionIntent, "
                  "dataState: ${taskDataState.toBriefInfo()}",
            );
          }
          // TaskSubmitIntent
          else if (originExecutionIntent is TaskSubmitIntent<TASK_INIT_DATA,
              TASK_RESULT_DATA, FORM_OUTPUT>) {
            return NxtExecutionUnit.yes(
              debug: debug,
              executionUnit: _TaskSubmitExecutionUnit<TASK_INIT_DATA,
                  TASK_RESULT_DATA, FORM_INPUT,FORM_OUTPUT>(
                xTask: this,
                executionIntent: originExecutionIntent,
              ),
              info:
                  "Task (4.2.2), ${getClassNameWithoutGenerics(task)}, _executionIntent: $originExecutionIntent, "
                  "dataState: ${taskDataState.toBriefInfo()}",
            );
          } else {
            return NxtExecutionUnit.no(
              debug: debug,
              info:
                  "Task (4.2.3), ${getClassNameWithoutGenerics(task)}, unhandled _executionIntent: $originExecutionIntent, "
                  "dataState: ${taskDataState.toBriefInfo()}",
            );
          }
        }
        // originExecutionIntent == null.
        else {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
                "Task (4.3), ${getClassNameWithoutGenerics(task)}, _executionIntent: $originExecutionIntent, "
                "dataState: ${taskDataState.toBriefInfo()}",
          );
        }
      }
    }

    // =========================================================================
    // 5. DATA STATE = SUBMISSION ATTEMPTED SUCCESS.
    // =========================================================================
    else if (taskDataState.isSubmissionAttemptedSuccess) {
      return NxtExecutionUnit.no(
        debug: debug,
        info:
            "Task (5.1), ${getClassNameWithoutGenerics(task)}, _executionIntent: $originExecutionIntent, "
            "dataState: ${taskDataState.toBriefInfo()}",
      );
    }

    // =========================================================================
    // 6. UNHANDLED / FALLTHROUGH STATE
    // =========================================================================
    return NxtExecutionUnit.no(
      debug: debug,
      info:
          "Task (6.1), ${getClassNameWithoutGenerics(task)}, _executionIntent: $originExecutionIntent, "
          "dataState: ${taskDataState.toBriefInfo()}, isVisible: $isVisible",
    );
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

  TaskLoadInitDataIntent<TASK_INIT_DATA, TASK_RESULT_DATA>
      _createAndSetTaskIntentLoadInitData() {
    final executionIntent =
        TaskLoadInitDataIntent<TASK_INIT_DATA, TASK_RESULT_DATA>();
    _executionIntent = executionIntent;
    return executionIntent;
  }
}
