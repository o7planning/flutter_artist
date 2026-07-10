import 'package:flutter_artist/flutter_artist.dart';

/// Defines the synchronization strategies used to re-evaluate and merge
/// remote server mutation footprints into the active runtime block viewport.
enum BlockViewportSyncStrategy {
  /// **Default Strategy (Full Convergence)**: Merges current on-screen IDs with the modified
  /// effective IDs, fetches the complete unified set, and overwrites the active list.
  ///
  /// *Ideal for generic update/upsert actions where consistency is paramount.*
  convergeAll(priority: 3),

  /// **Native Re-Query**: Ignores precise ID pooling and forces a clean page-bound
  /// layout query sequence to maintain strict pagination integrity.
  forceNativeQuery(priority: 2),

  /// **Incremental Merge**: Fetches *only* the newly mutated effective IDs and appends/merges
  /// them directly into the existing viewport without touching unchanged items.
  ///
  /// *Highly optimized for Batch/Multi-Creation scenarios to save bandwidth.*
  incrementalMerge(priority: 1);

  /// The weight of strictness and integrity enforcement.
  /// Higher priority overrides laxer synchronization options.
  final int priority;

  const BlockViewportSyncStrategy({required this.priority});

  bool get willReplace {
    switch (this) {
      case BlockViewportSyncStrategy.forceNativeQuery:
      case BlockViewportSyncStrategy.convergeAll:
        return true;
      case BlockViewportSyncStrategy.incrementalMerge:
        return false;
    }
  }

  bool get willMerge => !willReplace;

  /// Resolves the dominant strategy by evaluating weights between two components.
  /// If one of the strategies is null, the non-null strategy takes precedence.
  static BlockViewportSyncStrategy? resolveMax(
    BlockViewportSyncStrategy? a,
    BlockViewportSyncStrategy? b,
  ) {
    if (a == null) return b;
    if (b == null) return a;
    return a.priority >= b.priority ? a : b;
  }

  @Deprecated("Xoa di")
  bool get forceRequery {
    switch (this) {
      case BlockViewportSyncStrategy.convergeAll:
      case BlockViewportSyncStrategy.incrementalMerge:
      case BlockViewportSyncStrategy.forceNativeQuery:
        return true;
    }
  }
}
