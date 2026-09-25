part of '../core.dart';

/// Runtime execution wrapper for [Task], managing intent delegation,
/// single-stage progress lifecycle, and state mutation.
class XTask<
    TASK_DATA extends TaskData, //
    TASK_INPUT extends FormInput,
    ADDITIONAL_FORM_DATA extends AdditionalFormRelatedData> {
  final XActivity xActivity;

  final Task<TASK_DATA, TASK_INPUT, ADDITIONAL_FORM_DATA> task;

  bool _executed = false;

  bool get executed => _executed;

  String get name => task.name;

  int get xActivityId => xActivity.xActivityId;

  ExecHint _execHint = ExecHint.none;

  ExecHint get execHint => _execHint;

  TaskBaseExecutionIntent<TASK_DATA, dynamic, dynamic>? _executionIntent;

  TaskBaseExecutionIntent<TASK_DATA, dynamic, dynamic>? get executionIntent =>
      _executionIntent;

  XTask._({
    required this.xActivity,
    required this.task,
  });

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

  /// Evaluates and yields the next operational execution unit for this Task.
  NxtExecutionUnit _getNextExecutionUnit({required bool debug}) {
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
        final TaskExecutionIntent<TASK_DATA> intentToUse;
        if (executionIntent is TaskExecutionIntent<TASK_DATA>) {
          intentToUse = executionIntent;
        } else {
          intentToUse = _createAndSetTaskIntentExecution(
            lastIntentInfo: "Pending Trigger",
          );
        }

        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _TaskExecutionUnit(
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
        final TaskExecutionIntent<TASK_DATA> intentToUse;
        if (executionIntent is TaskExecutionIntent<TASK_DATA>) {
          intentToUse = executionIntent;
        } else {
          intentToUse = _createAndSetTaskIntentExecution(
            lastIntentInfo: "Stale Invalidation Trigger",
          );
        }

        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _TaskExecutionUnit(
            xTask: this,
            executionIntent: intentToUse,
          ),
          info:
              "Task (2.1), ${getClassNameWithoutGenerics(task)}, _executionIntent: $intentToUse, "
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
      // 3.0. Intercept terminal Done intent to prevent duplicate scheduler cycles
      if (executionIntent is TaskDoneIntent) {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
              "Task (3.0), ${getClassNameWithoutGenerics(task)}, _executionIntent: $executionIntent, "
              "dataState: ${taskDataState.toBriefInfo()}",
        );
      }

      // 3.1. Force execution explicitly requested via ExecHint
      if (_execHint == ExecHint.force) {
        final TaskExecutionIntent<TASK_DATA> intentToUse;
        if (executionIntent is TaskExecutionIntent<TASK_DATA>) {
          intentToUse = executionIntent;
        } else {
          intentToUse = _createAndSetTaskIntentExecution(
            lastIntentInfo: "Force ExecHint Trigger",
          );
        }

        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _TaskExecutionUnit(
            xTask: this,
            executionIntent: intentToUse,
          ),
          info:
              "Task (3.1), ${getClassNameWithoutGenerics(task)}, _executionIntent: $intentToUse, "
              "dataState: ${taskDataState.toBriefInfo()}, execHint: $_execHint, isVisible: $isVisible",
        );
      }

      // 3.2. Handle active execution intents dispatched imperatively
      if (executionIntent != null) {
        if (executionIntent is TaskNullIntent) {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
                "Task (3.2.1), ${getClassNameWithoutGenerics(task)}, _executionIntent: $executionIntent, "
                "dataState: ${taskDataState.toBriefInfo()}",
          );
        } else if (executionIntent is TaskExecutionIntent<TASK_DATA>) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _TaskExecutionUnit(
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
    _executionIntent = TaskDoneIntent<TASK_DATA>(
      lastIntentInfo: lastIntentInfo,
    );
  }

  TaskExecutionIntent<TASK_DATA> _createAndSetTaskIntentExecution({
    required String lastIntentInfo,
  }) {
    final executionIntent = TaskExecutionIntent<TASK_DATA>(
      lastIntentInfo: lastIntentInfo,
    );
    _executionIntent = executionIntent;
    return executionIntent;
  }
}
