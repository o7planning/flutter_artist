part of '../core.dart';

/// The centralized boundary configuration defining how runtime block viewports
/// adapt, resolve, and merge mutation footprints under strict structural rules.
///
/// Under the hood, **FlutterArtist** operates with two fundamentally opposite
/// priority hierarchies depending on the active [BlockNativeQueryMode].
///
/// By default, a Block initializes in [BlockNativeQueryMode.pageableQuery] mode.
///
/// ---
///
/// ### ️ The Great Hierarchy Inversion Explained:
///
/// #### 1. Bounded Paginated Mode ([BlockNativeQueryMode.pageableQuery]) — **Default**
/// Designed for segmented datasets (e.g., `CategoryBlock` and `ProductBlock` with a strict `pageSize = 10`).
///
/// Imagine a user is on Page 2 viewing 10 items. They execute a `ProductMultiCreationBackendAction`
/// which successfully creates 3 new products on the server.
/// * **If we enforce [BlockViewportSyncStrategy.nativeQuery] (Worst UX)**: The block re-queries Page 2
///   from the server. Due to pagination offsets, the server still returns exactly 10 items (potentially
///   shuffled, hiding the 3 newly created products). The user is left wondering if their action even worked.
/// * **If we enforce [BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery] (Best UX)**: The block
///   combines the 10 on-screen items with the 3 new product IDs, pulls them, and renders 13 items.
///   The new items appear instantly without breaking the local viewport flow.
///
/// Therefore, under pagination, the strictness priority is inverted to prioritize screen flow:
/// ```text
///   effectedAndViewportItemIdsQuery (Highest / Supreme Authority)
///     └── effectedItemIdsQuery (Incremental Merge)
///           └── nativeQuery (Lowest / Enforces strict Page boundaries, risks hiding new mutations)
/// ```
///
/// ---
///
/// #### 2. Unbounded Flat Mode ([BlockNativeQueryMode.fullQuery])
/// Designed for master-detail dependencies (e.g., `SalesOrderBlock` and `SalesOrderLineBlock` showing entire lists).
///
/// Imagine a user adds 3 new lines via an action. In a sales order, the server often calculates silent
/// side-effects (e.g., auto-generating discount rows, modifying tax line items, or recalculating totals).
/// * **If we enforce ID-pooling strategies ([BlockViewportSyncStrategy.effectedItemIdsQuery])**: The block
///   only requests the 3 explicit IDs it knows about, completely missing the silent server-side mutations
///   and discount rows.
/// * **If we enforce [BlockViewportSyncStrategy.nativeQuery] (Best UX)**: The block sweeps the entire endpoint,
///   fetching all lines and capturing every side-effect and auto-generated entity perfectly.
///
/// Therefore, under flat query layouts, the priority demands full structural cleanup:
/// ```text
///   nativeQuery (Highest / Supreme Authority)
///     └── effectedAndViewportItemIdsQuery
///           └── effectedItemIdsQuery (Lowest / Localized merge only)
/// ```
class BlockViewportSyncConfig {
  /// The minimum strategy enforced when the block is operating in [BlockNativeQueryMode.fullQuery] (no pagination).
  ///
  /// For master-detail structures like `SalesOrderLineBlock`, this baseline defaults to [BlockViewportSyncStrategy.nativeQuery]
  /// to guarantee that all implicit server-side side-effects, automatic discounts, and calculations are cleanly swept and synchronized.
  final BlockViewportSyncStrategy minStrategyOnFullQueryMode;

  /// The minimum strategy enforced when the block is operating in [BlockNativeQueryMode.pageableQuery] (strictly paginated).
  ///
  /// For strict paginated lists like `ProductBlock` (e.g., `pageSize = 10`), this baseline defaults to [BlockViewportSyncStrategy.effectedItemIdsQuery].
  /// This ensures that localized incremental merges or full screen merges ([BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery])
  /// take absolute precedence over [BlockViewportSyncStrategy.nativeQuery], preventing native page-queries from hiding
  /// newly mutated items from the active viewport.
  final BlockViewportSyncStrategy minStrategyOnPageableQueryMode;

  const BlockViewportSyncConfig({
    this.minStrategyOnFullQueryMode = BlockViewportSyncStrategy.nativeQuery,
    this.minStrategyOnPageableQueryMode =
        BlockViewportSyncStrategy.effectedItemIdsQuery,
  });

  /// **Lenient (Economy) Boundary Configuration**
  ///
  /// This configuration prioritizes low network overhead and minimal database queries
  /// over strict visual synchronization. It grants maximum freedom to the backend actions
  /// to execute localized merges without forcing full-scale re-queries.
  ///
  /// ### Resolved Hierarchies:
  ///
  /// #### 1. Under [BlockNativeQueryMode.fullQuery] (Floor: [BlockViewportSyncStrategy.effectedItemIdsQuery])
  /// ```text
  ///   nativeQuery (Highest)
  ///     └── effectedAndViewportItemIdsQuery
  ///           └── effectedItemIdsQuery (Floor / Allowed)
  /// ```
  ///
  /// #### 2. Under [BlockNativeQueryMode.pageableQuery] (Floor: [BlockViewportSyncStrategy.nativeQuery])
  /// ```text
  ///   effectedAndViewportItemIdsQuery (Highest)
  ///     └── effectedItemIdsQuery
  ///           └── nativeQuery (Floor / Allowed - Risks offset shifts, but extremely cheap)
  /// ```
  const BlockViewportSyncConfig.lenient()
      : minStrategyOnFullQueryMode =
      BlockViewportSyncStrategy.effectedItemIdsQuery,
        minStrategyOnPageableQueryMode = BlockViewportSyncStrategy.nativeQuery;

  /// **Strict (Defensive) Boundary Configuration**
  ///
  /// This configuration enforces the highest tier of visual synchronization and data integrity.
  /// It establishes aggressive barriers that prevent any lax, partial sync strategies from executing,
  /// ensuring the user's viewport is always perfectly reconciled at the cost of higher query workloads.
  ///
  /// ### Resolved Hierarchies:
  ///
  /// #### 1. Under [BlockNativeQueryMode.fullQuery] (Floor: [BlockViewportSyncStrategy.nativeQuery])
  /// ```text
  ///   nativeQuery (Highest & Floor - ONLY full re-queries are permitted to sweep side-effects)
  ///     └── [BLOCKED] effectedAndViewportItemIdsQuery
  ///           └── [BLOCKED] effectedItemIdsQuery
  /// ```
  ///
  /// #### 2. Under [BlockNativeQueryMode.pageableQuery] (Floor: [BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery])
  /// ```text
  ///   effectedAndViewportItemIdsQuery (Highest & Floor - Forces full screen consolidation)
  ///     └── [BLOCKED] effectedItemIdsQuery
  ///           └── [BLOCKED] nativeQuery
  /// ```
  const BlockViewportSyncConfig.strict()
      : minStrategyOnFullQueryMode = BlockViewportSyncStrategy.nativeQuery,
        minStrategyOnPageableQueryMode =
            BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery;
}
