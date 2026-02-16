class DebugBlockOptions {
  final bool showLastQueryType;
  final bool showUiActive;
  final bool showBlockDataState;
  final bool showLastQueryResultState;
  final bool showPerformQueryCount;
  final bool showPerformLoadItemCount;
  final bool showItemCount;
  final bool showCurrentItemChangeCount;
  final bool showFilterCriteriaChangeCount;
  final bool showFilterCriteria;
  final bool showHasCurrentItem;

  const DebugBlockOptions({
    this.showLastQueryType = true,
    this.showUiActive = true,
    this.showBlockDataState = true,
    this.showPerformQueryCount = true,
    this.showPerformLoadItemCount = true,
    this.showItemCount = true,
    this.showCurrentItemChangeCount = true,
    this.showFilterCriteriaChangeCount = true,
    this.showFilterCriteria = true,
    this.showHasCurrentItem = true,
    this.showLastQueryResultState = true,
  });

  const DebugBlockOptions.custom({
    this.showLastQueryType = false,
    this.showUiActive = false,
    this.showBlockDataState = false,
    this.showPerformQueryCount = false,
    this.showPerformLoadItemCount = false,
    this.showItemCount = false,
    this.showCurrentItemChangeCount = false,
    this.showFilterCriteria = false,
    this.showFilterCriteriaChangeCount = false,
    this.showHasCurrentItem = false,
    this.showLastQueryResultState = false,
  });
}
