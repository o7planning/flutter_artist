part of '../core.dart';

int __activitySequence = 0;

abstract class Activity extends _Core {
  Activity get activity => this;

  late final ActivityStructure _activityStruct;

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

  String get name => FlutterArtist.desk._getActivityName(runtimeType);

  String get activityId => "${name}_$_activityLocalId";

  late final _ActivityUiComponents ui = _ActivityUiComponents(activity: this);

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
}
