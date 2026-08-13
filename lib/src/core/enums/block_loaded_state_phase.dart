/// Represents the fine-grained operational phase or execution footprint
/// of a [Block] while maintaining a valid baseline dataset in [DataState.loaded].
enum BlockLoadedStatePhase {
  /// **Idle / Baseline Normal**
  /// The block is fully rendered, stable, and has no pending background errors or active operations.
  idle,

  /// **Active Background Re-querying (Refetching / Syncing)**
  /// The block is actively executing a background re-query (e.g., Pull-to-Refresh or Event Sync).
  /// Baseline items remain visible in the viewport with an active background loading indicator.
  refetching,

  /// **Active Infinite Scroll / Pagination**
  /// The block is fetching the next page of items.
  /// Existing viewport items remain visible, while a bottom loading spinner is rendered.
  fetchingMore,

  /// **Background Re-query Failed**
  /// A background re-query (Full Refetch or Event Sync) failed.
  /// Baseline items remain intact in the viewport, accompanied by a top/toast error notification.
  refetchFailed,

  /// **Pagination Fetch Failed**
  /// Fetching the next page failed.
  /// Baseline items remain intact, while the bottom list footer renders a "Retry" button.
  fetchMoreFailed,

  /// **Backend Action Synchronization Failed**
  /// A [BlockBackendAction] succeeded on the database, but the subsequent automated
  /// dataset reload / reconciliation phase failed.
  /// Local baseline items are preserved, while an error indicator is dispatched to notify the user.
  ///
  /// *(Note: Single-item operations like local deletion or quick-updates modify items
  /// directly in memory without disrupting the overall dataset state).*
  mutationFailed;

  /// Helper flag indicating if the block is currently performing an active async network operation.
  bool get isWorking => this == refetching || this == fetchingMore;

  /// Helper flag indicating if any background, paginated, or action-sync operation recently failed.
  bool get hasError =>
      this == refetchFailed ||
      this == fetchMoreFailed ||
      this == mutationFailed;
}
