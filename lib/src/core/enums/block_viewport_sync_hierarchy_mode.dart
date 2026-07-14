import '_block_viewport_sync_strategy.dart';

/// Defines the priority hierarchy modes for viewport synchronization inside a Block.
///
/// This configuration determines which strategy holds ultimate authority (is highest)
/// when resolving sync conflicts between the requested action and the block constraints.
enum BlockViewportSyncHierarchyMode {
  /// **Native Query Supremacy**: Places [BlockViewportSyncStrategy.nativeQuery]
  /// at the peak of the hierarchy. Best for flat datasets with complex server-side side-effects.
  ///
  /// Hierarchy tree:
  /// ```text
  /// nativeQuery (Highest)
  ///   └── effectedAndViewportItemIdsQuery
  ///         └── effectedItemIdsQuery (Lowest)
  /// ```
  nativeQueryIsHighest,

  /// **Convergence Supremacy**: Places [BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery]
  /// at the peak of the hierarchy. Best for strict pagination structures where
  /// maintaining active screen indexes is paramount.
  ///
  /// Hierarchy tree:
  /// ```text
  /// effectedAndViewportItemIdsQuery (Highest)
  ///   └── nativeQuery
  ///         └── effectedItemIdsQuery (Lowest)
  /// ```
  effectedAndViewportItemIdsQueryIsHighest;
}
