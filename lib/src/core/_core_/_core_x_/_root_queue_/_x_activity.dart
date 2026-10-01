part of '../../core.dart';

/// Root queue item representing a stateful process container (Activity),
/// managing child [XProzess] prozesses and atomic [XTask] units.
abstract class XActivity extends XRootQueueItem {
  final XActivityType xActivityType;

  final Activity activity;

  late final int xActivityId;
  late final int xModuleId;

  int _executionUnitStep = 0;

  @override
  String get _fullName => "@XActivity-${activity.name}";

  final Map<String, XTask> xTaskMap = {};

  final List<XTask> allXTasks = [];

  final List<XTaskFormModel> allXTaskFormModels = [];

  final Map<String, XStage> xStageMap = {};
  final Map<String, XProzess> xProzessMap = {};
  final List<XProzess> allXProzesses = [];

  XActivity({
    required this.activity,
    required this.xActivityType,
  })  : xModuleId = __xModuleSequence++,
        xActivityId = __xActivitySequence++ {
    // 1. Build and bind active runtime Tasks
    for (final Task task in activity.tasks) {
      final TaskFormModel? formModel = task.formModel;
      XTaskFormModel? xTaskFormModel;
      if (formModel != null) {
        //
        // Create new XTaskFormModel via 'formModel._createXTaskFormModel' method
        // to have the same Generics Parameters with task.
        //
        xTaskFormModel = formModel._createXTaskFormModel(formInput: null);
        allXTaskFormModels.add(xTaskFormModel);
      }
      final xTask = task._createXTask(
        xActivity: this,
        xTaskFormModel: xTaskFormModel,
      );
      xTaskFormModel?.xTask = xTask;
      xTaskMap[task.name] = xTask;
      allXTasks.add(xTask);
    }

    // 2. Build and bind active runtime Prozesses & Stages
    for (final Prozess prozess in activity.prozesses) {
      final xProzess = prozess._createXProzess(
        xActivity: this,
      );
      xProzessMap[prozess.name] = xProzess;
      allXProzesses.add(xProzess);

      for (final xStage in xProzess.allXStages) {
        xStageMap[xStage.name] = xStage;
      }
    }
    //
    _updateFromActivityForFirstTime();
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void _updateFromActivityForFirstTime() {
    for (XTask xTask in allXTasks) {
      final TaskDataState dataState = xTask.task.dataState;
      bool hasActiveUiX = xTask.task.ui.hasTaskContext();
      if (hasActiveUiX) {
        if (dataState.isPending || dataState.isStale) {
          xTask.setExecHintToGreater(ExecHint.force);
        }
      }
    }
    //
    for (XProzess xProzess in allXProzesses) {
      List<Stage> stages = xProzess.prozess.stages;
      final Stage? firstStage = stages.firstOrNull;
      if (firstStage == null) {
        continue;
      }
      final XStage firstXStage = xProzess.findXStageById(firstStage.stageId)!;

      for (Stage stage in stages) {
        final XStage xStage = xProzess.findXStageById(stage.stageId)!;
        final StageDataState stageDataStage = stage.dataState;
        if (stageDataStage.isNone) {
          break;
        }
        if (stageDataStage.isPending || stageDataStage.isStale) {
          xStage.setExecHintToGreater(ExecHint.force);
          break;
        }
        //
        // OK Now isFresh ...
        //
        if (stageDataStage.isSubmissionAttemptedSuccess) {
          continue;
        }
        // Else (isSubmissionAttemptedFail)
        break;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  XStage? findXStageByName(String name) {
    return xStageMap[name];
  }

  // ***************************************************************************
  // ***************************************************************************

  XTask? findXTaskByName(String name) => xTaskMap[name];

  XProzess? findXProzessByName(String name) => xProzessMap[name];

  // ***************************************************************************
  // ***************************************************************************

  /// Resolves the next unit to execute across Tasks and active Prozess stages.
  NxtExecutionUnit? _getNextExecutionUnit({required bool debug}) {
    if (debug) {
      if (++_executionUnitStep == 1) {
        print(
            "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ BEGIN ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
      }
    }
    PrintUtils.debug(debug,
        "\nACTIVITY EXECUTION UNIT (Step $_executionUnitStep) >>> ${getClassNameWithoutGenerics(this)}.getNextExecutionUnit()...");

    // Priority 1: Check atomic standalone Tasks
    for (final xTask in allXTasks) {
      final next = xTask._getNextExecutionUnit(debug: debug);
      if (next.yes) {
        return next;
      }
    }

    // Priority 2: Check multi-stage Prozesses
    for (final xProzess in allXProzesses) {
      final next = xProzess._getNextExecutionUnit(debug: debug);
      if (next != null && next.yes) {
        return next;
      }
    }

    return null;
  }
}
