class DebugScalarOptions {
  final bool showClassDefinition;
  final bool showLastQueryType;
  final bool showUiActive;
  final bool showScalarDataState;
  final bool showLastQueryResultState;
  final bool showPerformQueryCount;
  final bool showFilterCriteriaChangeCount;
  final bool showFilterCriteria;

  const DebugScalarOptions({
    this.showClassDefinition = true,
    this.showLastQueryType = true,
    this.showUiActive = true,
    this.showScalarDataState = true,
    this.showPerformQueryCount = true,
    this.showFilterCriteriaChangeCount = true,
    this.showFilterCriteria = true,
    this.showLastQueryResultState = true,
  });

  const DebugScalarOptions.custom({
    this.showClassDefinition = false,
    this.showLastQueryType = false,
    this.showUiActive = false,
    this.showScalarDataState = false,
    this.showPerformQueryCount = false,
    this.showFilterCriteria = false,
    this.showFilterCriteriaChangeCount = false,
    this.showLastQueryResultState = false,
  });
}
