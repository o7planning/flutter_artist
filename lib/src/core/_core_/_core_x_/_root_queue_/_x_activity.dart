part of '../../core.dart';

int __xActivitySequence = 0;

/// Root queue item representing a stateful process container (Activity),
/// managing child [XFlow] workflows and atomic [XTask] units.
abstract class XActivity extends XRootQueueItem {
  final XActivityType xActivityType;

  final Activity activity;
  late final int xActivityId;

  int _executionUnitStep = 0;

  @override
  String get _fullName => "@XActivity-${activity.name}";

  final Map<String, XTask> xTaskMap = {};
  final List<XTask> allXTasks = [];

  final Map<String, XFlow> xFlowMap = {};
  final List<XFlow> allXFlows = [];

  XActivity({
    required this.activity,
    required this.xActivityType,
  }) : xActivityId = __xActivitySequence++ {
    // 1. Build and bind active runtime Tasks
    for (final Task task in activity.tasks) {
      final xTask = task._createXTask(
        xActivity: this,
      );
      xTaskMap[task.name] = xTask;
      allXTasks.add(xTask);
    }

    // 2. Build and bind active runtime Flows & Stages
    for (final Flow flow in activity.flows) {
      final xFlow = flow._createXFlow(
        xActivity: this,
      );
      xFlowMap[flow.name] = xFlow;
      allXFlows.add(xFlow);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  XTask? findXTaskByName(String name) => xTaskMap[name];

  XFlow? findXFlowByName(String name) => xFlowMap[name];

  // ***************************************************************************
  // ***************************************************************************

  /// Resolves the next unit to execute across Tasks and active Flow stages.
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

    // Priority 2: Check multi-stage Flows
    for (final xFlow in allXFlows) {
      final next = xFlow._getNextExecutionUnit(debug: debug);
      if (next != null && next.yes) {
        return next;
      }
    }

    return null;
  }
}
