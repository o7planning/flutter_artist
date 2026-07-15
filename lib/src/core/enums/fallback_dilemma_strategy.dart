/// Defines the behavior rules for managing existing viewport elements
/// when a page-shifting or re-query invocation encounters a network failure.
enum FallbackDilemmaStrategy {
  /// **Preserve Stable Cache (Default)**: Keeps historical on-screen rows intact,
  /// maintaining a [DataState.ready] posture to avoid user panic.
  ///
  /// *Ideal for fluid user experiences during temporary network drops.*
  preserveStableCache,

  /// **Evict Stale Content**: Forcefully purges all existing items, wipes the viewport
  /// via [ListUpdateStrategy.replace], and triggers a strict [DataState.error] boundary.
  ///
  /// *Ideal for critical queries where displaying outdated or ghost data is strictly prohibited.*
  evictStaleContent,
}
