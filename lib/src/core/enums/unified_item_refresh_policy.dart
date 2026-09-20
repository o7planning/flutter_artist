/// Defines the policy determining how a [Block] refreshes its current item data
/// (and its corresponding item details) during query or synchronization flows.
enum UnifiedItemRefreshPolicy {
  /// Always forces a remote data fetch to reload the item, bypassing cached
  /// states, stale flags, or viewport visibility heuristics.
  ///
  /// Use this when data consistency is strictly required on every refresh trigger
  /// regardless of UI context demand.
  always,

  /// (Default Behavior).
  ///
  /// Automatically resolves whether a remote refresh is necessary based on
  /// runtime heuristics, such as whether an active item context is visible
  /// (`ui.hasItemContext()`), whether data is stale, or if `ITEM == ITEM_DETAIL`.
  ///
  /// Prevents redundant network roundtrips when the item detail is not actively
  /// observed on screen.
  auto;
}
