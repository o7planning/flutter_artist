part of '_calc.dart';

class TaskExecutionCalculator {
  static TaskNextUnitOutput calculate(TaskNextUnitInput input) {
    final state = input.dataState;
    final intent = input.currentIntent;
    final hint = input.execHint;
    final executed = input.executed;
    final isVisible = input.isVisible;

    String buildInfo(String branch) {
      return "$branch, ${input.modelName}, _executionIntent: $intent, "
          "dataState: ${state.toBriefInfo()}, execHint: $hint, isVisible: $isVisible";
    }

    // 0.0
    if (intent is TaskDoneIntent) {
      return TaskNextUnitOutput(
        action: TaskExecutionAction.none,
        debugInfo: buildInfo("Task (0.0)"),
      );
    }

    // =========================================================================
    // 1. DATA STATE = PENDING
    // =========================================================================
    if (state.isPending) {
      final bool shouldExecute =
          (hint == ExecHint.force || isVisible) && !executed;
      if (shouldExecute) {
        final bool isRestart = intent is TaskRestartIntent;
        return TaskNextUnitOutput(
          action: TaskExecutionAction.restart,
          missingIntent: isRestart ? null : MissingIntentType.restart,
          preserveCurrentIntent: !isRestart && intent != null,
          debugInfo: buildInfo("Task (1.1)"),
        );
      } else {
        return TaskNextUnitOutput(
          action: TaskExecutionAction.none,
          debugInfo: buildInfo("Task (1.2)"),
        );
      }
    }

    // =========================================================================
    // 2. DATA STATE = STALE
    // =========================================================================
    else if (state.isStale) {
      // IMPORTANT: No condition: isVisible (?? TODO: Review in test case).
      final bool shouldExecute =
          (hint == ExecHint.force || isVisible) && !executed;
      if (shouldExecute) {
        final bool isRestart = intent is TaskRestartIntent;
        return TaskNextUnitOutput(
          action: TaskExecutionAction.restart,
          missingIntent: isRestart ? null : MissingIntentType.restart,
          preserveCurrentIntent: !isRestart && intent != null,
          debugInfo: buildInfo("Task (2.1)"),
        );
      } else {
        return TaskNextUnitOutput(
          action: TaskExecutionAction.none,
          debugInfo: buildInfo("Task (2.2)"),
        );
      }
    }

    // =========================================================================
    // 3. DATA STATE = FRESH
    // =========================================================================
    else if (state.isFresh) {
      if (hint == ExecHint.force) {
        final bool isRestart = intent is TaskRestartIntent;
        return TaskNextUnitOutput(
          action: TaskExecutionAction.restart,
          missingIntent: isRestart ? null : MissingIntentType.restart,
          preserveCurrentIntent: !isRestart && intent != null,
          debugInfo: buildInfo("Task (3.1)"),
        );
      }

      if (intent != null) {
        if (intent is TaskNullIntent) {
          return TaskNextUnitOutput(
            action: TaskExecutionAction.none,
            debugInfo: buildInfo("Task (3.2.1)"),
          );
        } else if (intent is TaskSubmitIntent) {
          return TaskNextUnitOutput(
            action: TaskExecutionAction.submit,
            debugInfo: buildInfo("Task (3.2.2)"),
          );
        } else {
          return TaskNextUnitOutput(
            action: TaskExecutionAction.none,
            debugInfo: buildInfo("Task (3.2.3)"),
          );
        }
      }

      return TaskNextUnitOutput(
        action: TaskExecutionAction.none,
        debugInfo: buildInfo("Task (3.3)"),
      );
    }

    // =========================================================================
    // 4. DATA STATE = SUBMISSION ATTEMPTED FAILED
    // =========================================================================
    else if (state.isSubmissionAttemptedFailed) {
      final bool shouldReload =
          (hint == ExecHint.force || isVisible) && !executed;
      if (shouldReload) {
        final bool isRestart = intent is TaskRestartIntent;
        return TaskNextUnitOutput(
          action: TaskExecutionAction.restart,
          missingIntent: isRestart ? null : MissingIntentType.restart,
          preserveCurrentIntent: !isRestart && intent != null,
          debugInfo: buildInfo("Task (4.1)"),
        );
      } else {
        if (intent != null) {
          if (intent is TaskNullIntent) {
            return TaskNextUnitOutput(
              action: TaskExecutionAction.none,
              debugInfo: buildInfo("Task (4.2.1)"),
            );
          } else if (intent is TaskSubmitIntent) {
            return TaskNextUnitOutput(
              action: TaskExecutionAction.submit,
              debugInfo: buildInfo("Task (4.2.2)"),
            );
          } else {
            return TaskNextUnitOutput(
              action: TaskExecutionAction.none,
              debugInfo: buildInfo("Task (4.2.3)"),
            );
          }
        } else {
          return TaskNextUnitOutput(
            action: TaskExecutionAction.none,
            debugInfo: buildInfo("Task (4.3)"),
          );
        }
      }
    }

    // =========================================================================
    // 5. DATA STATE = SUBMISSION ATTEMPTED SUCCESS
    // =========================================================================
    else if (state.isSubmissionAttemptedSuccess) {
      return TaskNextUnitOutput(
        action: TaskExecutionAction.none,
        debugInfo: buildInfo("Task (5.1)"),
      );
    }

    // =========================================================================
    // 6. UNHANDLED / FALLTHROUGH STATE
    // =========================================================================
    return TaskNextUnitOutput(
      action: TaskExecutionAction.none,
      debugInfo: buildInfo("Task (6.1)"),
    );
  }
}
