part of '../core.dart';

int __activitySequence = 0;

abstract class Activity extends _Core {
  Activity get activity => this;

  late final ActivityStructure _activityStruct;

  late final debug = _ActivityDebugInfo(activity: this);

  late final ActivityConfig config;
  late final ActivityEffectiveConfig effectiveConfig;

  String? get description => _activityStruct.description;

  final Map<String, Task> __taskMap = {};
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  final Map<String, Flow> __flowMap = {};
  final List<Flow> _flows = [];

  List<Flow> get flows => List.unmodifiable(_flows);

  final List<TaskFormModel> _allTaskFormModels = [];
  final List<StageFormModel> _allStageFormModels = [];

  late final int _activityLocalId = __activitySequence++;

  String get name => FlutterArtist.desk._getActivityV1Name(runtimeType);

  String get activityId => "${name}_$_activityLocalId";

  void _markAsOrphaned(bool orphaned) {
    if (orphaned) {
      __orphanedAt = DateTime.now();
    } else {
      __orphanedAt = null;
    }
  }

  DateTime? __orphanedAt;

  DateTime? get orphanedAt => __orphanedAt;

  bool get markedAsOrphan => __orphanedAt != null;

  late final ui = _ActivityUiComponents(activity: this);

  Activity() {
    __onInit();
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Very Dangerous Method. Call Internal only.
  ///
  String ___registerError(String message) {
    FlutterArtist._clearActivitiesAndShelves();
    return _createFatalAppError(message);
  }

  // ***************************************************************************
  // ***************************************************************************

  void __onInit() {
    _activityStruct = defineActivityStructure();
    config = _activityStruct._config;
    effectiveConfig =
        ActivityEffectiveConfig._fromConfig(_activityStruct._config);

    //
    // 1. Tasks Registration:
    //
    for (Task task in _activityStruct.tasks) {
      if (__taskMap.containsKey(task.name)) {
        throw ___registerError(
          "Duplicate Task '${task.name}' in '${getClassName(this)}'\n"
          "Double-check ${getClassName(this)}.defineActivityStructure() method",
        );
      }
      __taskMap[task.name] = task;
      _tasks.add(task);
      task._bindToActivity(this);

      if (task.formModel != null) {
        _allTaskFormModels.add(task.formModel!);
      }
    }

    //
    // 2. Flows & Stages Registration:
    //
    for (Flow flow in _activityStruct.flows) {
      if (__flowMap.containsKey(flow.name)) {
        throw ___registerError(
          "Duplicate Flow '${flow.name}' in '${getClassName(this)}'\n"
          "Double-check ${getClassName(this)}.defineActivityStructure() method",
        );
      }
      __flowMap[flow.name] = flow;
      _flows.add(flow);
      flow._bindToActivity(this);

      // Register Stage Form Models
      for (Stage stage in flow.stages) {
        if (stage.formModel != null) {
          _allStageFormModels.add(stage.formModel!);
        }
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Task? findTask(String taskName) {
    return __taskMap[taskName];
  }

  Flow? findFlow(String flowName) {
    return __flowMap[flowName];
  }

  // ***************************************************************************
  // ***************************************************************************

  ActivityStructure defineActivityStructure();

  @override
  String toString() {
    return "${getClassName(this)}($name)";
  }

  // ***************************************************************************
  // ***************************************************************************

  // LOGIC: #0000 (Same as Shelf._dispatchNaturalQuery())
  Future<void> _dispatchNaturalExecution({
    required ExecutionTrace executionTrace,
  }) async {
    debug._lazyLoadId++;
    //
    executionTrace.addInfo(
      codeId: "#01000",
      shortDesc:
          "Find lazy model-components (stage, task) that are in a state where they need to execute or load data.",
    );
    //
    // Natural Execute:
    //
    final XActivity xActivity =
        _XActivityActivityNaturalExec(activity: activity);
    try {
      executionTrace.addInfo(
        codeId: "#01100",
        shortDesc: "Create ${debugObjHtml(xActivity)} for <b>Natural-Load</b>.",
        note:
            "<b>XActivity</b> is a <b>RootQueueItem</b> and contains multiple <b>Execution Units</b>.",
      );
      executionTrace.addNonControllableCall(
        codeId: "#01120",
        caller: xActivity,
        methodName: "_initExecExecutionUnits",
        suffixShortDesc: "",
      );
      //
      executionTrace.addInfo(
        codeId: "#01160",
        shortDesc:
            "Add ${debugObjHtml(xActivity)} (RootQueueItem) to <b>Root-Queue</b>.",
      );
      FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xActivity);
      //
      executionTrace.addNonControllableCall(
        codeId: "#01200",
        caller: FlutterArtist.executor,
        methodName: "_executeExecutionUnitQueue",
        suffixShortDesc:
            "To execute <b>RootQueueItem(s)</b> on the queue and its <b>Execution Units</b>...",
      );
      await FlutterArtist.executor._executeExecutionUnitQueue();
    } finally {
      // Nothing
    }
  }
}
