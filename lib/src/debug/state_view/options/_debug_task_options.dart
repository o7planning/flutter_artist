class DebugTaskOptions {
  final bool showClassDefinition;
  final bool showLastQueryType;
  final bool showUiActive;
  final bool showTaskDataState;
  final bool showPerformLoadInitDataCount;
  final bool showInitData;
  final bool showResultData;

  const DebugTaskOptions({
    this.showClassDefinition = true,
    this.showLastQueryType = true,
    this.showUiActive = true,
    this.showTaskDataState = true,
    this.showPerformLoadInitDataCount = true,
    this.showInitData = true,
    this.showResultData = true,
  });

  const DebugTaskOptions.custom({
    this.showClassDefinition = false,
    this.showLastQueryType = false,
    this.showUiActive = false,
    this.showTaskDataState = false,
    this.showPerformLoadInitDataCount = false,
    this.showInitData = false,
    this.showResultData = false,
  });
}
