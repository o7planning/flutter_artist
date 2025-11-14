class FilterDebugOptions {
  final bool showFilterUIActive;
  final bool showInitiatedAtLeastOnce;
  final bool showFilterDataState;
  final bool showFilterLoadCount;
  final bool showFilterActivityCount;
  final bool showFilterCriteria;

  const FilterDebugOptions({
    this.showFilterUIActive = true,
    this.showInitiatedAtLeastOnce = true,
    this.showFilterDataState = true,
    this.showFilterLoadCount = true,
    this.showFilterActivityCount = true,
    this.showFilterCriteria = true,
  });

  const FilterDebugOptions.custom({
    this.showFilterUIActive = false,
    this.showInitiatedAtLeastOnce = false,
    this.showFilterDataState = false,
    this.showFilterLoadCount = false,
    this.showFilterActivityCount = false,
    this.showFilterCriteria = false,
  });
}
