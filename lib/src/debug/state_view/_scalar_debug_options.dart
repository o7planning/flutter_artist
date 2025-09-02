class ScalarDebugOptions {
  final bool showLastQueryType;
  final bool showUIActive;
  final bool showScalarDataState;
  final bool showLastQueryResultState;
  final bool showCallApiQueryCount;
  final bool showCallApiRefreshItemCount;
  final bool showFilterCriteriaChangeCount;
  final bool showFilterCriteria;

  const ScalarDebugOptions({
    this.showLastQueryType = true,
    this.showUIActive = true,
    this.showScalarDataState = true,
    this.showCallApiQueryCount = true,
    this.showCallApiRefreshItemCount = true,
    this.showFilterCriteriaChangeCount = true,
    this.showFilterCriteria = true,
    this.showLastQueryResultState = true,
  });

  const ScalarDebugOptions.custom({
    this.showLastQueryType = false,
    this.showUIActive = false,
    this.showScalarDataState = false,
    this.showCallApiQueryCount = false,
    this.showCallApiRefreshItemCount = false,
    this.showFilterCriteria = false,
    this.showFilterCriteriaChangeCount = false,
    this.showLastQueryResultState = false,
  });
}
