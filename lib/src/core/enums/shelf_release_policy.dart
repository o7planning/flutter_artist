enum ShelfReleasePolicy {
  /// Keep the shelf instance in memory even when no UI components are active.
  retain,

  /// Automatically release and mark the shelf as orphaned when all attached UI components are unmounted.
  unmount,
}
