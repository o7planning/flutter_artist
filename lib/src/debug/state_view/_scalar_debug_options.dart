class ScalarDebugOptions {
  final bool showLastQueryType;
  final bool showUIActive;
  final bool showQueryDataState;
  final bool showLastQueryResultState;
  final bool showCallApiQueryCount;
  final bool showCallApiRefreshItemCount;
  final bool showFilterCriteriaChangeCount;
  final bool showFilterCriteria;

  const ScalarDebugOptions({
    this.showLastQueryType = true,
    this.showUIActive = true,
    this.showQueryDataState = true,
    this.showCallApiQueryCount = true,
    this.showCallApiRefreshItemCount = true,
    this.showFilterCriteriaChangeCount = true,
    this.showFilterCriteria = true,
    this.showLastQueryResultState = true,
  });

  const ScalarDebugOptions.custom({
    this.showLastQueryType = false,
    this.showUIActive = false,
    this.showQueryDataState = false,
    this.showCallApiQueryCount = false,
    this.showCallApiRefreshItemCount = false,
    this.showFilterCriteria = false,
    this.showFilterCriteriaChangeCount = false,
    this.showLastQueryResultState = false,
  });
}
