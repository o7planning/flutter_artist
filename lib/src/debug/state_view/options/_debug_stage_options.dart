class DebugStageOptions {
  final bool showUiActive;
  final bool showStageDataState;
  final bool showPerformLoadInitDataCount;
  final bool showHasInitData;
  final bool showHasResultData;

  const DebugStageOptions({
    this.showUiActive = true,
    this.showStageDataState = true,
    this.showPerformLoadInitDataCount = true,
    this.showHasInitData = true,
    this.showHasResultData = true,
  });

  const DebugStageOptions.custom({
    this.showUiActive = false,
    this.showStageDataState = false,
    this.showPerformLoadInitDataCount = false,
    this.showHasInitData = false,
    this.showHasResultData = false,
  });
}
