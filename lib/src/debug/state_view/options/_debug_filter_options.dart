class DebugFilterOptions {
  final bool showFilterUIActive;
  final bool showInitiatedAtLeastOnce;
  final bool showFilterDataState;
  final bool showFilterLoadCount;
  final bool showFilterActivityCount;
  final bool showFilterCriteria;

  const DebugFilterOptions({
    this.showFilterUIActive = true,
    this.showInitiatedAtLeastOnce = true,
    this.showFilterDataState = true,
    this.showFilterLoadCount = true,
    this.showFilterActivityCount = true,
    this.showFilterCriteria = true,
  });

  const DebugFilterOptions.custom({
    this.showFilterUIActive = false,
    this.showInitiatedAtLeastOnce = false,
    this.showFilterDataState = false,
    this.showFilterLoadCount = false,
    this.showFilterActivityCount = false,
    this.showFilterCriteria = false,
  });
}
