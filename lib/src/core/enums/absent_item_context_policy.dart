/// Defines the policy governing how a [Block] handles its `currentItem` selection
/// when no actively visible UI view demands the item-level data context
/// (i.e., when `ui.hasItemContext()` evaluates to `false`).
// OLD: ItemAbsentRepresentativePolicy
enum AbsentItemContextPolicy {
  /// (Default Behavior).
  ///
  /// When the item context is absent from the active UI hierarchy, the [Block]
  /// will NOT attempt to automatically resolve or select an item as `currentItem`.
  ///
  /// This avoids unnecessary downstream state notifications and prevents potential
  /// cascade queries on child blocks or attached forms when the item details
  /// are not currently observed.
  tryNotSetAnItemAsCurrent,

  /// When the item context is absent from the active UI hierarchy, the [Block]
  /// will still attempt to preserve or select an item as `currentItem` ONLY IF:
  /// 1. The candidate item exists within the newly queried item list.
  /// 2. The item summary and detail types are identical (`ITEM == ITEM_DETAIL`),
  ///    guaranteeing that no additional remote API call is needed to fetch item details.
  ///
  /// This keeps the current selection intact in memory without incurring network overhead.
  trySetAnItemAsCurrent;
}
