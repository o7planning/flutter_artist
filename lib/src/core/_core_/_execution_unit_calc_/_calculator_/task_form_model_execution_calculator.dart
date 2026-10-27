part of '_calc.dart';

class TaskFormExecutionCalculator {
  static TaskFormNextUnitOutput calculate(TaskFormNextUnitInput input) {
    final state = input.dataState;
    final intent = input.currentIntent;
    final hint = input.formLoadHint;
    final isVisible = input.isVisible;
    final taskDataState = input.taskDataState;

    String buildInfo(String branch) {
      return "$branch, (${input.taskName}), _executionIntent: $intent, "
          "taskDataState: $taskDataState, formDataState: ${state.toBriefInfo()}, _formLoadHint: $hint, visibleX: $isVisible";
    }

    if (intent is FormModelDoneIntent) {
      return TaskFormNextUnitOutput(
        action: TaskFormExecutionAction.none,
        debugInfo: buildInfo("TaskFormModel (0.1)"),
      );
    }

    if (!input.isTaskStateReady) {
      return TaskFormNextUnitOutput(
        action: TaskFormExecutionAction.none,
        debugInfo: buildInfo("TaskFormModel (0.2)"),
      );
    }

    // =========================================================================
    // 1. DATA STATE = NONE
    // =========================================================================
    if (state.isNone) {
      return TaskFormNextUnitOutput(
        action: TaskFormExecutionAction.none,
        debugInfo: buildInfo("TaskFormModel (1.1)"),
      );
    }

    // =========================================================================
    // 2. DATA STATE = PENDING
    // =========================================================================
    else if (state.isPending) {
      if (intent is FormModelDataLoadIntent) {
        return TaskFormNextUnitOutput(
          action: TaskFormExecutionAction.loadData,
          debugInfo: buildInfo("TaskFormModel (2.1)"),
        );
      }

      final bool shouldLoad = (hint == FormLoadHint.force || isVisible);
      if (shouldLoad) {
        return TaskFormNextUnitOutput(
          action: TaskFormExecutionAction.loadData,
          missingIntent: MissingIntentType.dataLoadOrQuery,
          preserveCurrentIntent: intent != null,
          debugInfo: buildInfo("TaskFormModel (2.2.1)"),
        );
      } else {
        return TaskFormNextUnitOutput(
          action: TaskFormExecutionAction.none,
          debugInfo: buildInfo("TaskFormModel (2.2.2)"),
        );
      }
    }

    // =========================================================================
    // 3. DATA STATE = STALE
    // =========================================================================
    else if (state.isLoadedStale) {
      final bool shouldLoad = (hint == FormLoadHint.force || isVisible);
      if (shouldLoad) {
        final bool isLoadIntent = intent is FormModelDataLoadIntent;
        return TaskFormNextUnitOutput(
          action: TaskFormExecutionAction.loadData,
          missingIntent:
              isLoadIntent ? null : MissingIntentType.dataLoadOrQuery,
          preserveCurrentIntent: !isLoadIntent && intent != null,
          debugInfo: buildInfo("TaskFormModel (3.1.1)"),
        );
      } else {
        return TaskFormNextUnitOutput(
          action: TaskFormExecutionAction.none,
          debugInfo: buildInfo("TaskFormModel (3.1.2)"),
        );
      }
    }

    // =========================================================================
    // 4. DATA STATE = FATAL ERROR
    // =========================================================================
    else if (state.isFatalError) {
      final bool shouldLoad = (hint == FormLoadHint.force || isVisible);
      if (shouldLoad) {
        final bool isLoadIntent = intent is FormModelDataLoadIntent;
        return TaskFormNextUnitOutput(
          action: TaskFormExecutionAction.loadData,
          missingIntent:
              isLoadIntent ? null : MissingIntentType.dataLoadOrQuery,
          preserveCurrentIntent: !isLoadIntent && intent != null,
          debugInfo: buildInfo("TaskFormModel (4.1.1)"),
        );
      } else {
        return TaskFormNextUnitOutput(
          action: TaskFormExecutionAction.none,
          debugInfo: buildInfo("TaskFormModel (4.1.2)"),
        );
      }
    }

    // =========================================================================
    // 5. DATA STATE = FRESH
    // =========================================================================
    else if (state.isLoadedFresh) {
      if (hint == FormLoadHint.force) {
        final bool isLoadIntent = intent is FormModelDataLoadIntent;
        return TaskFormNextUnitOutput(
          action: TaskFormExecutionAction.loadData,
          missingIntent:
              isLoadIntent ? null : MissingIntentType.dataLoadOrQuery,
          preserveCurrentIntent: !isLoadIntent && intent != null,
          debugInfo: buildInfo("TaskFormModel (5.1.2)"),
        );
      }

      if (intent != null) {
        if (intent is FormModelViewChangeIntent) {
          return TaskFormNextUnitOutput(
            action: TaskFormExecutionAction.viewChange,
            debugInfo: buildInfo("TaskFormModel (5.2.2)"),
          );
        } else if (intent is FormModelDataLoadIntent) {
          return TaskFormNextUnitOutput(
            action: TaskFormExecutionAction.loadData,
            debugInfo: buildInfo("TaskFormModel (5.2.3)"),
          );
        } else if (intent is FormModelPatchFormFieldsIntent) {
          return TaskFormNextUnitOutput(
            action: TaskFormExecutionAction.patchFormFields,
            debugInfo: buildInfo("TaskFormModel (5.2.4)"),
          );
        } else {
          return TaskFormNextUnitOutput(
            action: TaskFormExecutionAction.none,
            debugInfo: buildInfo("TaskFormModel (5.2.5)"),
          );
        }
      }

      return TaskFormNextUnitOutput(
        action: TaskFormExecutionAction.none,
        debugInfo: buildInfo("TaskFormModel (5.3)"),
      );
    }

    // =========================================================================
    // 6. UNHANDLED / FALLTHROUGH STATE
    // =========================================================================
    return TaskFormNextUnitOutput(
      action: TaskFormExecutionAction.none,
      debugInfo: buildInfo("TaskFormModel (6.1)"),
    );
  }
}
