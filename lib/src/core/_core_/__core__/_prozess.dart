part of '../core.dart';

abstract class Prozess<
    STAGE_ENUM extends Enum, //
    PROZESS_CONTEXT_DATA extends ProzessContextData> extends _Core {
  final String name;

  final List<STAGE_ENUM> _stageHistory = [];
  late STAGE_ENUM _currentStageId;
  ProzessDataState _dataState = ProzessDataStateNone();
  late final PROZESS_CONTEXT_DATA _prozessContextData;

  STAGE_ENUM get currentStageId => _currentStageId;

  ProzessDataState get dataState => _dataState;

  PROZESS_CONTEXT_DATA get contextData => _prozessContextData;

  List<STAGE_ENUM> get stageHistory => List.unmodifiable(_stageHistory);

  final Map<STAGE_ENUM, Stage> __stageMap = {};
  final List<Stage> _stages = [];

  List<Stage> get stages => List.unmodifiable(_stages);

  late final Activity activity;

  late final ui = _ProzessUiComponents(prozess: this);

  Prozess({required this.name}) {
    __initializeProzess();
  }

  // ***************************************************************************

  XProzess<STAGE_ENUM, PROZESS_CONTEXT_DATA> _createXProzess({
    required XActivity xActivity,
  }) {
    return XProzess<STAGE_ENUM, PROZESS_CONTEXT_DATA>._(
      flow: this,
      xActivity: xActivity,
    );
  }

  // ***************************************************************************

  void __initializeProzess() {
    final ProzessStructure<STAGE_ENUM, PROZESS_CONTEXT_DATA> flowStructure =
        defineProzessStructure();

    for (Stage stage in flowStructure.stages) {
      STAGE_ENUM stageId = stage.stageId as STAGE_ENUM;
      if (__stageMap.containsKey(stageId)) {
        throw "Duplicate Stage enum '${stage.stageId}' in Prozess '${getClassName(this)}'";
      }
      __stageMap[stageId] = stage;
      _stages.add(stage);
      stage._bindToProzess(this);
    }
  }

  void _bindToActivity(Activity parentActivity) {
    activity = parentActivity;
  }

  Stage? findStage(STAGE_ENUM stageId) {
    return __stageMap[stageId];
  }

  // ***************************************************************************

  ProzessStructure<STAGE_ENUM, PROZESS_CONTEXT_DATA> defineProzessStructure();

  Future<ApiResult<PROZESS_CONTEXT_DATA>> performLoadProzessContextData();

  // ***************************************************************************

  void moveToStage(STAGE_ENUM nextStageId) {
    _stageHistory.add(_currentStageId);
    _currentStageId = nextStageId;
  }

  bool stageBack() {
    if (_stageHistory.isNotEmpty) {
      _currentStageId = _stageHistory.removeLast();
      return true;
    }
    return false;
  }

  void _processStageSubmitResult(
      StageExecutionResult<STAGE_ENUM, StageResultData> result) {
    if (result.isFinished) {
      _dataState = ProzessDataStateCompleted();
      return;
    }
    if (result.nextStage != null) {
      moveToStage(result.nextStage!);
    }
  }
}
