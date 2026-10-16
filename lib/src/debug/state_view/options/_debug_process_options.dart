class DebugProzessOptions {
  final bool showClassDefinition;
  final bool showStagesInfo;
  final bool showUiActive;
  final bool showDataState;
  final bool showViewingStage;
  final bool showFrontierStage;
  final bool showInitData;
  final bool showContextData;
  final bool showStagePipeline;
  final bool showPerformLoadInitDataCount;
  final bool showStageReexecutionAllowed;

  const DebugProzessOptions({
    this.showClassDefinition = true,
    this.showStagesInfo = true,
    this.showUiActive = true,
    this.showDataState = true,
    this.showViewingStage = true,
    this.showFrontierStage = true,
    this.showInitData = true,
    this.showContextData = true,
    this.showStagePipeline = true,
    this.showPerformLoadInitDataCount = true,
    this.showStageReexecutionAllowed = true,
  });

  const DebugProzessOptions.custom({
    this.showClassDefinition = false,
    this.showStagesInfo = false,
    this.showUiActive = false,
    this.showDataState = false,
    this.showViewingStage = false,
    this.showFrontierStage = false,
    this.showInitData = false,
    this.showContextData = false,
    this.showStagePipeline = false,
    this.showPerformLoadInitDataCount = false,
    this.showStageReexecutionAllowed = false,
  });
}
