class DebugStageOptions {
  final bool showClassDefinition;
  final bool showUiActive;
  final bool showStageDataState;
  final bool showPerformLoadInitDataCount;
  final bool showInitData;
  final bool showResultData;

  const DebugStageOptions({
    this.showClassDefinition = true,
    this.showUiActive = true,
    this.showStageDataState = true,
    this.showPerformLoadInitDataCount = true,
    this.showInitData = true,
    this.showResultData = true,
  });

  const DebugStageOptions.custom({
    this.showClassDefinition = false,
    this.showUiActive = false,
    this.showStageDataState = false,
    this.showPerformLoadInitDataCount = false,
    this.showInitData = false,
    this.showResultData = false,
  });
}
