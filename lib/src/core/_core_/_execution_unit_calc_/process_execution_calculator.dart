part of '_calc.dart';

class ProzessExecutionCalculator {
  static ProzessNextUnitOutput calculate(ProzessNextUnitInput input) {
    final state = input.dataState;
    final intent = input.currentIntent;
    final hint = input.restartHint;
    final isVisible = input.isVisible;
    final initDataLoaded = input.initDataLoaded;

    String buildInfo(String branch) {
      return "$branch, ${input.modelName}, _executionIntent: $intent, "
          "dataState: ${state.toBriefInfo()}, restartHint: $hint, isVisible: $isVisible";
    }

    if (intent is ProzessDoneIntent) {
      return ProzessNextUnitOutput(
        action: ProzessExecutionAction.none,
        debugInfo: buildInfo("Prozess (0.0)"),
      );
    }

    // =========================================================================
    // 1. PENDING
    // =========================================================================
    if (state.isPending) {
      final bool shouldLoadInitData =
          (hint == ExecHint.force || isVisible) && !initDataLoaded;

      if (shouldLoadInitData) {
        final bool isRestart = intent is ProzessRestartIntent;
        return ProzessNextUnitOutput(
          action: ProzessExecutionAction.restart,
          missingIntent: isRestart ? null : MissingIntentType.restart,
          preserveCurrentIntent: !isRestart && intent != null,
          debugInfo: buildInfo("Prozess (1.1)"),
        );
      } else {
        return ProzessNextUnitOutput(
          action: ProzessExecutionAction.none,
          debugInfo: buildInfo("Prozess (1.2)"),
        );
      }
    }

    // =========================================================================
    // 2. LOADED STALE
    // =========================================================================
    else if (state.isStale) {
      final bool shouldLoadInitData =
          (hint == ExecHint.force || isVisible) && !initDataLoaded;

      if (shouldLoadInitData) {
        final bool isRestart = intent is ProzessRestartIntent;
        return ProzessNextUnitOutput(
          action: ProzessExecutionAction.restart,
          missingIntent: isRestart ? null : MissingIntentType.restart,
          preserveCurrentIntent: !isRestart && intent != null,
          debugInfo: buildInfo("Prozess (2.1)"),
        );
      } else {
        return ProzessNextUnitOutput(
          action: ProzessExecutionAction.none,
          debugInfo: buildInfo("Prozess (2.2)"),
        );
      }
    }

    // =========================================================================
    // 3. LOADED FRESH
    // =========================================================================
    else if (state.isFresh) {
      final bool shouldLoadInitData =
          (hint == ExecHint.force) && !initDataLoaded;

      if (shouldLoadInitData) {
        final bool isRestart = intent is ProzessRestartIntent;
        return ProzessNextUnitOutput(
          action: ProzessExecutionAction.restart,
          missingIntent: isRestart ? null : MissingIntentType.restart,
          preserveCurrentIntent: !isRestart && intent != null,
          debugInfo: buildInfo("Prozess (3.1)"),
        );
      } else {
        if (intent is ProzessDetermineNextStageIntent) {
          return ProzessNextUnitOutput(
            action: ProzessExecutionAction.determineNextStage,
            debugInfo: buildInfo("Prozess (3.2.1)"),
          );
        } else {
          return ProzessNextUnitOutput(
            action: ProzessExecutionAction.none,
            debugInfo: buildInfo("Prozess (3.2.2)"),
          );
        }
      }
    }

    // =========================================================================
    // 4. TRANSITIONING FAILED
    // =========================================================================
    else if (state.isTransitioningFailed) {
      final bool shouldLoadInitData =
          (hint == ExecHint.force) && !initDataLoaded;

      if (shouldLoadInitData) {
        final bool isRestart = intent is ProzessRestartIntent;
        return ProzessNextUnitOutput(
          action: ProzessExecutionAction.restart,
          missingIntent: isRestart ? null : MissingIntentType.restart,
          preserveCurrentIntent: !isRestart && intent != null,
          debugInfo: buildInfo("Prozess (4.1)"),
        );
      } else {
        if (intent is ProzessDetermineNextStageIntent) {
          return ProzessNextUnitOutput(
            action: ProzessExecutionAction.determineNextStage,
            debugInfo: buildInfo("Prozess (4.2.1)"),
          );
        } else {
          return ProzessNextUnitOutput(
            action: ProzessExecutionAction.none,
            debugInfo: buildInfo("Prozess (4.2.2)"),
          );
        }
      }
    }

    // =========================================================================
    // 5. TRANSITIONING SUCCESS
    // =========================================================================
    else if (state.isTransitioningSuccess) {
      final bool shouldLoadInitData =
          (hint == ExecHint.force) && !initDataLoaded;

      if (shouldLoadInitData) {
        final bool isRestart = intent is ProzessRestartIntent;
        return ProzessNextUnitOutput(
          action: ProzessExecutionAction.restart,
          missingIntent: isRestart ? null : MissingIntentType.restart,
          preserveCurrentIntent: !isRestart && intent != null,
          debugInfo: buildInfo("Prozess (5.1)"),
        );
      } else {
        if (intent is ProzessRestartIntent) {
          return ProzessNextUnitOutput(
            action: ProzessExecutionAction.restart,
            debugInfo: buildInfo("Prozess (5.2.1)"),
          );
        } else if (intent is ProzessDetermineNextStageIntent) {
          return ProzessNextUnitOutput(
            action: ProzessExecutionAction.determineNextStage,
            debugInfo: buildInfo("Prozess (5.2.2)"),
          );
        }
        return ProzessNextUnitOutput(
          action: ProzessExecutionAction.none,
          debugInfo: buildInfo("Prozess (5.2.3)"),
        );
      }
    }

    // =========================================================================
    // 6. COMPLETED
    // =========================================================================
    else if (state.isCompleted) {
      if (intent is ProzessRestartIntent) {
        return ProzessNextUnitOutput(
          action: ProzessExecutionAction.restart,
          debugInfo: buildInfo("Prozess (6.1)"),
        );
      }
      return ProzessNextUnitOutput(
        action: ProzessExecutionAction.none,
        debugInfo: buildInfo("Prozess (6.2)"),
      );
    }

    // =========================================================================
    // 7. OTHERS
    // =========================================================================
    return ProzessNextUnitOutput(
      action: ProzessExecutionAction.none,
      debugInfo: buildInfo("Prozess (7.0)"),
    );
  }
}
