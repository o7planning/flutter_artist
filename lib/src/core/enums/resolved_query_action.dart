/// Resolved query execution action determined by [BlockQueryStrategyResolver].
enum ResolvedQueryAction {
  /// Perform a full query across the entire Block dataset ([Block.performQuery]).
  performQuery,

  /// Perform a targeted query for specific item IDs ([Block.performQueryByItemIds]).
  performQueryByItemIds,
}
