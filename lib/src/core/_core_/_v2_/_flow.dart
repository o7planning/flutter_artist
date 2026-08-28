part of '../core.dart';

abstract class Flow<STAGE_ENUM extends Enum,
    FLOW_CONTEXT_DATA extends FlowContextData> extends _Core {
  final String name;

  final List<STAGE_ENUM> _stageHistory = [];
  late STAGE_ENUM _currentStageId;
  FlowDataState _dataState = FlowDataState.none;
  late final FLOW_CONTEXT_DATA _flowContextData;

  STAGE_ENUM get currentStageId => _currentStageId;
  FlowDataState get dataState => _dataState;
  FLOW_CONTEXT_DATA get contextData => _flowContextData;
  List<STAGE_ENUM> get stageHistory => List.unmodifiable(_stageHistory);

  final Map<STAGE_ENUM, Stage> __stageMap = {};
  final List<Stage> _stages = [];
  List<Stage> get stages => List.unmodifiable(_stages);

  late final Activity activity;
  late final _FlowUiComponents ui = _FlowUiComponents(flow: this);

  Flow({required this.name}) {
    __initializeFlow();
  }

  void __initializeFlow() {
    final FlowStructure<STAGE_ENUM, FLOW_CONTEXT_DATA> flowStructure =
        defineFlowStructure();

    for (Stage stage in flowStructure.stages) {
      STAGE_ENUM stageId = stage.stageId as STAGE_ENUM;
      if (__stageMap.containsKey(stageId)) {
        throw "Duplicate Stage enum '${stage.stageId}' in Flow '${getClassName(this)}'";
      }
      __stageMap[stageId] = stage;
      _stages.add(stage);
      stage._bindToFlow(this);
    }
  }

  void _bindToActivity(Activity parentActivity) {
    activity = parentActivity;
  }

  Stage? findStage(STAGE_ENUM stageId) {
    return __stageMap[stageId];
  }

  FlowStructure<STAGE_ENUM, FLOW_CONTEXT_DATA> defineFlowStructure();

  Future<ApiResult<FLOW_CONTEXT_DATA>> performLoadFlowContextData();

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
      StageExecutionResult<STAGE_ENUM, StageData> result) {
    if (result.isFinished) {
      _dataState = FlowDataState.completed;
      return;
    }
    if (result.nextStage != null) {
      moveToStage(result.nextStage!);
    }
  }
}
