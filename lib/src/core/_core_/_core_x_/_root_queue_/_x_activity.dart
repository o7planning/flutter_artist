part of '../../core.dart';

int __xActivitySequence = 0;

/// Root queue item representing a stateful process container (Activity),
/// managing child [XProzess] workprozesss and atomic [XTask] units.
abstract class XActivity extends XRootQueueItem {
  final XActivityType xActivityType;

  final Activity activity;
  late final int xActivityId;

  int _executionUnitStep = 0;

  @override
  String get _fullName => "@XActivity-${activity.name}";

  final Map<String, XTask> xTaskMap = {};

  final List<XTask> allXTasks = [];

  final Map<String, XStage> xStageMap = {};
  final Map<String, XProzess> xProzessMap = {};
  final List<XProzess> allXProzesss = [];

  XActivity({
    required this.activity,
    required this.xActivityType,
  }) : xActivityId = __xActivitySequence++ {
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
      xTaskMap[task.name] = xTask;
      allXTasks.add(xTask);
    }

    // 2. Build and bind active runtime Prozesses & Stages
    for (final Prozess prozess in activity.prozesss) {
      final xProzess = prozess._createXProzess(
        xActivity: this,
      );
      xProzessMap[prozess.name] = xProzess;
      allXProzesss.add(xProzess);
    }
  }

  final List<XTaskFormModel> allXTaskFormModels = [];

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
        "\nACTIVITY EXECUTION UNIT ($_executionUnitStep) >>> ${getClassNameWithoutGenerics(this)}.getNextExecutionUnit()...");

    // Priority 1: Check atomic standalone Tasks
    for (final xTask in allXTasks) {
      final next = xTask._getNextExecutionUnit(debug: debug);
      if (next.yes) {
        return next;
      }
    }

    // Priority 2: Check multi-stage Prozesses
    for (final xProzess in allXProzesss) {
      final next = xProzess._getNextExecutionUnit(debug: debug);
      if (next != null && next.yes) {
        return next;
      }
    }

    return null;
  }
}
