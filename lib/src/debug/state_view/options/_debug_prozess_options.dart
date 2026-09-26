class DebugProzessOptions {
  final bool showUiActive;
  final bool showCurrentStage;
  final bool showStageHistory;
  final bool showContextData;
  final bool showStagePipeline;

  const DebugProzessOptions({
    this.showUiActive = true,
    this.showCurrentStage = true,
    this.showStageHistory = true,
    this.showContextData = true,
    this.showStagePipeline = true,
  });

  const DebugProzessOptions.custom({
    this.showUiActive = false,
    this.showCurrentStage = false,
    this.showStageHistory = false,
    this.showContextData = false,
    this.showStagePipeline = false,
  });
}
