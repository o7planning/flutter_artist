class DebugFilterOptions {
  final bool showFilterUiActive;
  final bool showInitiatedAtLeastOnce;
  final bool showFilterDataState;
  final bool showFilterLoadCount;
  final bool showFilterActivityCount;
  final bool showFilterCriteria;

  const DebugFilterOptions({
    this.showFilterUiActive = true,
    this.showInitiatedAtLeastOnce = true,
    this.showFilterDataState = true,
    this.showFilterLoadCount = true,
    this.showFilterActivityCount = true,
    this.showFilterCriteria = true,
  });

  const DebugFilterOptions.custom({
    this.showFilterUiActive = false,
    this.showInitiatedAtLeastOnce = false,
    this.showFilterDataState = false,
    this.showFilterLoadCount = false,
    this.showFilterActivityCount = false,
    this.showFilterCriteria = false,
  });
}
