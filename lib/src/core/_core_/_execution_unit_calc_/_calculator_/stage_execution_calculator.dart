part of '_calc.dart';

class StageExecutionCalculator {
  static StageNextUnitOutput calculate(StageNextUnitInput input) {
    final state = input.dataState;
    final intent = input.currentIntent;
    final hint = input.execHint;
    final executed = input.executed;
    final isVisible = input.isVisible;

    String buildInfo(String branch) {
      return "$branch, ${input.modelName}, _executionIntent: $intent, "
          "dataState: ${state.toBriefInfo()}, execHint: $hint, isVisible: $isVisible";
    }

    if (!input.isCurrentStage) {
      return StageNextUnitOutput(
        action: StageExecutionAction.none,
        debugInfo: buildInfo("Stage (0.0)"),
      );
    }

    if (intent is StageDoneIntent) {
      return StageNextUnitOutput(
        action: StageExecutionAction.none,
        debugInfo: buildInfo("Stage (0.1)"),
      );
    }

    // =========================================================================
    // 1. DATA STATE = PENDING
    // =========================================================================
    if (state.isPending) {
      final bool shouldExecute =
          (hint == ExecHint.force || isVisible) && !executed;
      if (shouldExecute) {
        final bool isRestart = intent is StageRestartIntent;
        return StageNextUnitOutput(
          action: StageExecutionAction.restart,
          missingIntent: isRestart ? null : MissingIntentType.restart,
          preserveCurrentIntent: !isRestart && intent != null,
          debugInfo: buildInfo("Stage (1.1)"),
        );
      } else {
        return StageNextUnitOutput(
          action: StageExecutionAction.none,
          debugInfo: buildInfo("Stage (1.2)"),
        );
      }
    }

    // =========================================================================
    // 2. DATA STATE = STALE
    // =========================================================================
    else if (state.isLoadedStale) {
      final bool shouldExecute =
          (hint == ExecHint.force || isVisible) && !executed;
      if (shouldExecute) {
        final bool isRestart = intent is StageRestartIntent;
        return StageNextUnitOutput(
          action: StageExecutionAction.restart,
          missingIntent: isRestart ? null : MissingIntentType.restart,
          preserveCurrentIntent: !isRestart && intent != null,
          debugInfo: buildInfo("Stage (2.1)"),
        );
      } else {
        return StageNextUnitOutput(
          action: StageExecutionAction.none,
          debugInfo: buildInfo("Stage (2.2)"),
        );
      }
    }

    // =========================================================================
    // 3. DATA STATE = FRESH
    // =========================================================================
    else if (state.isLoadedFresh) {
      if (hint == ExecHint.force) {
        final bool isRestart = intent is StageRestartIntent;
        return StageNextUnitOutput(
          action: StageExecutionAction.restart,
          missingIntent: isRestart ? null : MissingIntentType.restart,
          preserveCurrentIntent: !isRestart && intent != null,
          debugInfo: buildInfo("Stage (3.1)"),
        );
      }

      if (intent != null) {
        if (intent is StageNullIntent) {
          return StageNextUnitOutput(
            action: StageExecutionAction.none,
            debugInfo: buildInfo("Stage (3.2.1)"),
          );
        } else if (intent is StageSubmitIntent) {
          return StageNextUnitOutput(
            action: StageExecutionAction.submit,
            debugInfo: buildInfo("Stage (3.2.2)"),
          );
        } else {
          return StageNextUnitOutput(
            action: StageExecutionAction.none,
            debugInfo: buildInfo("Stage (3.2.3)"),
          );
        }
      }

      return StageNextUnitOutput(
        action: StageExecutionAction.none,
        debugInfo: buildInfo("Stage (3.3)"),
      );
    }

    // =========================================================================
    // 4. DATA STATE = SUBMISSION ATTEMPTED FAILED
    // =========================================================================
    else if (state.isSubmissionFailed) {
      final bool shouldReload = (hint == ExecHint.force) && !executed;
      if (shouldReload) {
        final bool isRestart = intent is StageRestartIntent;
        return StageNextUnitOutput(
          action: StageExecutionAction.restart,
          missingIntent: isRestart ? null : MissingIntentType.restart,
          preserveCurrentIntent: !isRestart && intent != null,
          debugInfo: buildInfo("Stage (4.1)"),
        );
      } else {
        if (intent != null) {
          if (intent is StageNullIntent) {
            return StageNextUnitOutput(
              action: StageExecutionAction.none,
              debugInfo: buildInfo("Stage (4.2.1)"),
            );
          } else if (intent is StageSubmitIntent) {
            return StageNextUnitOutput(
              action: StageExecutionAction.submit,
              debugInfo: buildInfo("Stage (4.2.2)"),
            );
          } else {
            return StageNextUnitOutput(
              action: StageExecutionAction.none,
              debugInfo: buildInfo("Stage (4.2.3)"),
            );
          }
        } else {
          return StageNextUnitOutput(
            action: StageExecutionAction.none,
            debugInfo: buildInfo("Stage (4.3)"),
          );
        }
      }
    }

    // =========================================================================
    // 5. DATA STATE = SUBMISSION ATTEMPTED SUCCESS
    // =========================================================================
    else if (state.isSubmissionSuccess) {
      return StageNextUnitOutput(
        action: StageExecutionAction.none,
        debugInfo: buildInfo("Stage (5.1)"),
      );
    }

    // =========================================================================
    // 6. UNHANDLED / FALLTHROUGH STATE
    // =========================================================================
    return StageNextUnitOutput(
      action: StageExecutionAction.none,
      debugInfo: buildInfo("Stage (6.1)"),
    );
  }
}
