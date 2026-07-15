import 'package:flutter_artist/flutter_artist.dart';

import 'block_native_query_mode.dart';

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

  /// Resolves the final effective [BlockViewportSyncStrategy] to be applied at runtime.
  ///
  /// This pure static resolver dynamically evaluates the structural priority hierarchies based on the
  /// impending [BlockNativeQueryMode]. It automatically extracts the matching backend intent,
  /// and enforces the respective floor and ceiling boundaries defined within the [BlockViewportSyncConfig]
  /// to protect the active viewport.
  ///
  /// If the extracted backend intent is null, it is treated as the lowest possible priority (weight 0),
  /// causing the resolver to safely upgrade it to the configured floor baseline.
  static BlockViewportSyncStrategy resolveViewportSyncStrategy2({
    required BlockNativeQueryMode nativeQueryMode,
    required BlockViewportSyncStrategy? backendIntentInFullQueryMode,
    required BlockViewportSyncStrategy? backendIntentInPageableQueryMode,
    required BlockViewportSyncConfig syncConfig,
  }) {
    switch (nativeQueryMode) {
      case BlockNativeQueryMode.fullQuery:
        // ---------------------------------------------------------------------
        // UNBOUNDED FLAT MODE: nativeQuery holds supreme authority.
        // Hierarchy: nativeQuery (3) > effectedAndViewportItemIdsQuery (2) > effectedItemIdsQuery (1) > null (0)
        // ---------------------------------------------------------------------
        final BlockViewportSyncStrategy floor =
            syncConfig.minStrategyOnFullQueryMode;
        final BlockViewportSyncStrategy? requestedIntent =
            backendIntentInFullQueryMode;

        final int requestedWeight = _getWeightUnderFullQuery(requestedIntent);
        final int floorWeight = _getWeightUnderFullQuery(floor);

        // Auto-upgrade if the requested strategy is weaker than the configured floor
        if (requestedWeight < floorWeight) {
          return floor;
        }

        // At this point, requestedWeight >= floorWeight.
        // Since floor is always a non-null enum, requestedIntent is guaranteed to be non-null here.
        return requestedIntent!;

      case BlockNativeQueryMode.pageableQuery:
        // ---------------------------------------------------------------------
        // BOUNDED PAGINATED MODE: effectedAndViewportItemIdsQuery holds supreme authority.
        // Hierarchy: effectedAndViewportItemIdsQuery (3) > effectedItemIdsQuery (2) > nativeQuery (1) > null (0)
        // ---------------------------------------------------------------------
        final BlockViewportSyncStrategy floor =
            syncConfig.minStrategyOnPageableQueryMode;
        final BlockViewportSyncStrategy? requestedIntent =
            backendIntentInPageableQueryMode;

        final int requestedWeight =
            _getWeightUnderPageableQuery(requestedIntent);
        final int floorWeight = _getWeightUnderPageableQuery(floor);

        BlockViewportSyncStrategy resolved;

        // Auto-upgrade if the requested strategy is weaker than the configured floor
        if (requestedWeight < floorWeight) {
          resolved = floor;
        } else {
          // Guaranteed non-null as it successfully cleared the floor baseline
          resolved = requestedIntent!;
        }

        // Ceiling Guard: Downgrade nativeQuery to full convergence to protect the active pagination viewport.
        // We only allow nativeQuery if the floor explicitly demands it.
        if (resolved == BlockViewportSyncStrategy.nativeQuery &&
            floor != BlockViewportSyncStrategy.nativeQuery) {
          resolved = BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery;
        }

        return resolved;
    }
  }

  /// Resolves the final effective [BlockViewportSyncStrategy] by consolidating a collection of
  /// deferred [BlockReceivedEventInfo] accumulated while the Block was inactive or hidden.
  ///
  /// This batch resolver extracts the maximum synchronization intent from all recorded events,
  /// accounts for global infrastructure updates (forcing maximum security if required), and clamps
  /// the unified intent strictly within the configured [BlockViewportSyncConfig] boundaries.
  static BlockViewportSyncStrategy resolveViewportSyncStrategy({
    required BlockNativeQueryMode nativeQueryMode,
    required BlockViewportSyncConfig syncConfig,
    required List<BlockReceivedEventInfo> receivedEventInfos,
  }) {
    // Edge case: If no events were accumulated, fallback safely to the lowest possible baseline
    if (receivedEventInfos.isEmpty) {
      return nativeQueryMode == BlockNativeQueryMode.fullQuery
          ? syncConfig.minStrategyOnFullQueryMode
          : syncConfig.minStrategyOnPageableQueryMode;
    }

    switch (nativeQueryMode) {
      case BlockNativeQueryMode.fullQuery:
        // ---------------------------------------------------------------------
        // UNBOUNDED FLAT MODE HIERARCHY:
        // nativeQuery (3) > effectedAndViewportItemIdsQuery (2) > effectedItemIdsQuery (1) > null (0)
        // ---------------------------------------------------------------------
        final BlockViewportSyncStrategy floor =
            syncConfig.minStrategyOnFullQueryMode;

        // Check if any event demands an absolute sweep due to missing mutation details (e.g., Storage Actions)
        final bool forceMax =
            receivedEventInfos.any((info) => info.requiresMaxSyncStrategy);
        if (forceMax) {
          return BlockViewportSyncStrategy
              .nativeQuery; // Highest authority in Full Query
        }

        // Extract the maximum requested intent weight among all accumulated events
        BlockViewportSyncStrategy? maxIntent;
        int maxWeight = 0;

        for (final info in receivedEventInfos) {
          final intent = info.syncStrategyOnFullQueryMode;
          final weight = _getWeightUnderFullQuery(intent);
          if (weight > maxWeight) {
            maxWeight = weight;
            maxIntent = intent;
          }
        }

        final int floorWeight = _getWeightUnderFullQuery(floor);
        if (maxWeight < floorWeight) {
          return floor;
        }
        return maxIntent!;

      case BlockNativeQueryMode.pageableQuery:
        // ---------------------------------------------------------------------
        // BOUNDED PAGINATED MODE HIERARCHY:
        // effectedAndViewportItemIdsQuery (3) > effectedItemIdsQuery (2) > nativeQuery (1) > null (0)
        // ---------------------------------------------------------------------
        final BlockViewportSyncStrategy floor =
            syncConfig.minStrategyOnPageableQueryMode;
        final bool forceMax =
            receivedEventInfos.any((info) => info.requiresMaxSyncStrategy);

        BlockViewportSyncStrategy maxIntent;
        int maxWeight;

        if (forceMax) {
          maxIntent = BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery;
          maxWeight = _getWeightUnderPageableQuery(maxIntent);
        } else {
          maxIntent = BlockViewportSyncStrategy.nativeQuery;
          maxWeight = 0;

          for (final info in receivedEventInfos) {
            final intent = info.syncStrategyOnPageableQueryMode;
            final weight = _getWeightUnderPageableQuery(intent);
            if (weight > maxWeight) {
              maxWeight = weight;
              maxIntent = intent!;
            }
          }
        }
        final int floorWeight = _getWeightUnderPageableQuery(floor);
        BlockViewportSyncStrategy resolved =
            maxWeight < floorWeight ? floor : maxIntent;

        // ️ RE-ARCHITECTED CEILING GUARD:
        if (resolved == BlockViewportSyncStrategy.nativeQuery &&
            floor != BlockViewportSyncStrategy.nativeQuery) {
          resolved = BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery;
        }

        return resolved;
    }
  }

  /// Calculates priority weights under the [BlockNativeQueryMode.fullQuery] hierarchy.
  ///
  /// Returns 0 for null values to force an automatic upgrade to the configured floor.
  static int _getWeightUnderFullQuery(BlockViewportSyncStrategy? strategy) {
    if (strategy == null) return 0;
    switch (strategy) {
      case BlockViewportSyncStrategy.nativeQuery:
        return 3;
      case BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery:
        return 2;
      case BlockViewportSyncStrategy.effectedItemIdsQuery:
        return 1;
    }
  }

  /// Calculates priority weights under the [BlockNativeQueryMode.pageableQuery] hierarchy.
  ///
  /// Returns 0 for null values to force an automatic upgrade to the configured floor.
  static int _getWeightUnderPageableQuery(BlockViewportSyncStrategy? strategy) {
    if (strategy == null) return 0;
    switch (strategy) {
      case BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery:
        return 3;
      case BlockViewportSyncStrategy.effectedItemIdsQuery:
        return 2;
      case BlockViewportSyncStrategy.nativeQuery:
        return 1;
    }
  }
}
