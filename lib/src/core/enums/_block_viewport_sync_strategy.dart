import 'package:flutter_artist/flutter_artist.dart';

/// Defines the synchronization strategies used to re-evaluate and merge
/// remote server mutation footprints into the active runtime block viewport.
enum BlockViewportSyncStrategy {
  /// **Default Strategy (Full Convergence)**: Merges current on-screen IDs with the modified
  /// effective IDs, fetches the complete unified set, and overwrites the active list.
  ///
  /// *Ideal for generic update/upsert actions where consistency is paramount.*
  convergeAll,

  /// **Incremental Merge**: Fetches *only* the newly mutated effective IDs and appends/merges
  /// them directly into the existing viewport without touching unchanged items.
  ///
  /// *Highly optimized for Batch/Multi-Creation scenarios to save bandwidth.*
  incrementalMerge,

  // /// **Current Guard (Eviction)**: Re-evaluates *only* the existing on-screen IDs.
  // /// Deleted or non-compliant records will naturally vanish from the returned dataset.
  // ///
  // /// *Best suited for destructive operations (delete, archive, or deactivate).*
  // refreshCurrentOnly,

  /// **Native Re-Query**: Ignores precise ID pooling and forces a clean page-bound
  /// layout query sequence to maintain strict pagination integrity.
  forceNativeQuery,

  // /// **Fire and Forget (None)**: Intentionally suppresses all network re-fetch streams.
  // ///
  // /// *Designed for analytical triggers, background procedures, or export executions.*
  // none
  ;

  bool get willReplace {
    switch (this) {
      case BlockViewportSyncStrategy.forceNativeQuery:
      case BlockViewportSyncStrategy.convergeAll:
        return true;
      case BlockViewportSyncStrategy.incrementalMerge:
        return false;
    }
  }

  bool get willMerge {
    return !willReplace;
  }

  @Deprecated("Xoa di")
  bool get forceRequery {
    switch (this) {
      case BlockViewportSyncStrategy.convergeAll:
      case BlockViewportSyncStrategy.incrementalMerge:
      case BlockViewportSyncStrategy.forceNativeQuery:
        // case BlockViewportSyncStrategy.refreshCurrentOnly:
        return true;
      // case BlockViewportSyncStrategy.none:
      //   return false;
    }
  }
}
