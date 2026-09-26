class DebugTaskOptions {
  final bool showLastQueryType;
  final bool showUiActive;
  final bool showTaskDataState;
  final bool showPerformLoadInitDataCount;

  const DebugTaskOptions({
    this.showLastQueryType = true,
    this.showUiActive = true,
    this.showTaskDataState = true,
    this.showPerformLoadInitDataCount = true,
  });

  const DebugTaskOptions.custom({
    this.showLastQueryType = false,
    this.showUiActive = false,
    this.showTaskDataState = false,
    this.showPerformLoadInitDataCount = false,
  });
}
