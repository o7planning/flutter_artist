class BlockDebugOptions {
  final bool showLastQueryType;
  final bool showUIActive;
  final bool showBlockDataState;
  final bool showLastQueryResultState;
  final bool showCallApiQueryCount;
  final bool showCallApiRefreshItemCount;
  final bool showItemCount;
  final bool showCurrentItemChangeCount;
  final bool showFilterCriteriaChangeCount;
  final bool showFilterCriteria;
  final bool showHasCurrentItem;

  const BlockDebugOptions({
    this.showLastQueryType = true,
    this.showUIActive = true,
    this.showBlockDataState = true,
    this.showCallApiQueryCount = true,
    this.showCallApiRefreshItemCount = true,
    this.showItemCount = true,
    this.showCurrentItemChangeCount = true,
    this.showFilterCriteriaChangeCount = true,
    this.showFilterCriteria = true,
    this.showHasCurrentItem = true,
    this.showLastQueryResultState = true,
  });

  const BlockDebugOptions.custom({
    this.showLastQueryType = false,
    this.showUIActive = false,
    this.showBlockDataState = false,
    this.showCallApiQueryCount = false,
    this.showCallApiRefreshItemCount = false,
    this.showItemCount = false,
    this.showCurrentItemChangeCount = false,
    this.showFilterCriteria = false,
    this.showFilterCriteriaChangeCount = false,
    this.showHasCurrentItem = false,
    this.showLastQueryResultState = false,
  });
}
