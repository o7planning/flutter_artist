import 'package:flutter_artist/flutter_artist.dart';

import 'block_viewport_sync_hierarchy_mode.dart';

/// Defines the synchronization strategies used to re-evaluate and merge
/// remote server mutation footprints into the active runtime block viewport.
enum BlockViewportSyncStrategy {
  /// **Native Re-Query**: Bypasses precise ID pooling and forces a clean,
  /// full-scale native query sequence to maintain strict pagination integrity.
  nativeQuery,

  /// **Full Convergence**: Merges current on-screen IDs with the mutated/effected IDs,
  /// fetches the complete unified set, and overwrites the active list view.
  effectedAndViewportItemIdsQuery,

  /// **Incremental Merge**: Fetches *only* the newly mutated/effected IDs and appends/merges
  /// them directly into the existing viewport without touching unchanged items.
  effectedItemIdsQuery;

  /// Returns true if the strategy requires completely flushing the existing viewport list.
  bool get willReplace {
    switch (this) {
      case BlockViewportSyncStrategy.nativeQuery:
      case BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery:
        return true;
      case BlockViewportSyncStrategy.effectedItemIdsQuery:
        return false;
    }
  }

  /// Returns true if the strategy performs a localized row injection merge.
  bool get willMerge => !willReplace;

  /// Resolves the final effective strategy by clamping the requested Action strategy
  /// strictly within the configured [BlockViewportSyncConfig] boundaries.
  static BlockViewportSyncStrategy resolveWithBoundaries({
    required BlockViewportSyncStrategy requestedActionStrategy,
    required BlockViewportSyncConfig syncConfig,
  }) {
    final BlockViewportSyncStrategy floor = syncConfig.minViewportSyncStrategy;
    final BlockViewportSyncHierarchyMode mode =
        syncConfig.viewportSyncHierarchyMode;

    // 1. Calculate relative weights based on the active hierarchy mode
    final int requestedWeight =
        _getWeightUnderMode(requestedActionStrategy, mode);
    final int floorWeight = _getWeightUnderMode(floor, mode);

    BlockViewportSyncStrategy resolved = requestedActionStrategy;

    // 2. Enforce floor baseline boundary (Auto-upgrade if the request is weaker than the floor)
    if (requestedWeight < floorWeight) {
      resolved = floor;
    }

    // 3. Enforce ceiling constraints: If the mode is effectedAndViewportItemIdsQueryIsHighest,
    // we do not allow nativeQuery to overrule the layout unless the floor explicitly demands it.
    if (mode ==
            BlockViewportSyncHierarchyMode
                .effectedAndViewportItemIdsQueryIsHighest &&
        requestedActionStrategy == BlockViewportSyncStrategy.nativeQuery &&
        floor != BlockViewportSyncStrategy.nativeQuery) {
      resolved = BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery;
    }

    return resolved;
  }

  /// Helper to calculate dynamic weights under the active hierarchy mode rule.
  static int _getWeightUnderMode(
      BlockViewportSyncStrategy strategy, BlockViewportSyncHierarchyMode mode) {
    if (strategy == BlockViewportSyncStrategy.effectedItemIdsQuery)
      return 1; // Always lowest

    switch (mode) {
      case BlockViewportSyncHierarchyMode.nativeQueryIsHighest:
        return strategy == BlockViewportSyncStrategy.nativeQuery ? 3 : 2;
      case BlockViewportSyncHierarchyMode.effectedAndViewportItemIdsQueryIsHighest:
        return strategy == BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery
            ? 3
            : 2;
    }
  }
}
