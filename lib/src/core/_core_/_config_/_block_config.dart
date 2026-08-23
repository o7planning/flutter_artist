part of '../core.dart';

/// Configuration schema defining the execution behavior, cache boundaries,
/// parent-child relational constraints, and event broadcasting rules for a [Block].
class BlockConfig {
  /// Dictates whether this block's query depends on properties within the
  /// ancestor's payload value, rather than just the ancestor's identity ([currentItem.id]).
  ///
  /// When set to `true`, if any ancestor transitions from FRESH to STALE,
  /// this child block will also automatically invalidate and transition to STALE.
  /// Defaults to `false`.
  final bool bindToAncestorPayloadState;

  /// Enforces a relational parent-link constraint on items loaded into memory.
  ///
  /// When set to `true`, developers MUST override `resolveParentBlockItemId()`
  /// to extract the foreign parent ID from each child item. Any item whose resolved
  /// parent ID does not match the parent block's currently selected item ID will be
  /// evicted from the in-memory item collection (it will not be deleted from persistent storage).
  /// Defaults to `false`.
  final bool enforceParentLinkConstraint;

  /// Prevents losing uncommitted or unsaved edits during refresh, pagination,
  /// or query mode switches.
  /// Defaults to `true`.
  final bool preventUnsavedChangesLoss;

  @Deprecated("No longer supported")
  final ItemAbsentRepresentativePolicy itemAbsentRepresentativePolicy;

  // IdentityBlockConfig
  @Deprecated("No longer supported")
  final UnifiedItemRefreshPolicy unifiedItemRefreshPolicy;

  final BlockHiddenAction onHideAction;

  /// When set to `true`, prevents mutating [nativeQueryMode] at runtime,
  /// strictly locking the block into its configured initial querying strategy.
  /// Defaults to `true`.
  final bool isNativeQueryModeLocked;

  /// The baseline querying strategy used by this block (e.g., [BlockNativeQueryMode.fullQuery]
  /// or [BlockNativeQueryMode.pageableQuery]).
  /// Defaults to [BlockNativeQueryMode.pageableQuery].
  final BlockNativeQueryMode nativeQueryMode;

  /// Pagination configuration (page index and page size) applied when [nativeQueryMode]
  /// is set to [BlockNativeQueryMode.pageableQuery].
  final Pageable pageable;

  /// Controls whether this block is permitted to broadcast data change events
  /// to external shelves and listeners across the ecosystem.
  /// Defaults to `false`.
  final bool eventBroadcastEnabled;

  final bool eventReactionEnabled;

  /// Additional domain data types explicitly broadcasted by this block beyond
  /// the primary ITEM and ITEM_DETAIL representations.
  final List<Type> extraBroadcastEvents;

  /// Defines the client-side in-memory sorting strategy applied to the item collection.
  /// Defaults to [SortStrategy.none].
  final SortStrategy clientSideSortStrategy;

  /// Configuration policies for viewport reconciliation and synchronization
  /// when mutating events affect the current dataset.
  final BlockViewportSyncConfig viewportSyncConfig;

  /// Unified event recipient configuration defining how this block reacts to
  /// external or internal domain data type broadcasts.
  ///
  /// Docs: 14769/27a
  final List<BlockEventReaction> reactions;

  /// Creates a configuration instance for a [Block].
  BlockConfig({
    this.bindToAncestorPayloadState = false,
    this.enforceParentLinkConstraint = false,
    this.itemAbsentRepresentativePolicy =
        ItemAbsentRepresentativePolicy.tryNotSetAnItemAsCurrent,
    this.unifiedItemRefreshPolicy = UnifiedItemRefreshPolicy.auto,
    this.preventUnsavedChangesLoss = true,
    this.viewportSyncConfig = const BlockViewportSyncConfig(),
    this.eventBroadcastEnabled = false,
    this.eventReactionEnabled = true,
    List<Type>? extraBroadcastEvents,
    this.isNativeQueryModeLocked = true,
    this.nativeQueryMode = BlockNativeQueryMode.pageableQuery,
    this.pageable = const Pageable(
      page: 1,
      pageSize: 20,
    ),
    this.clientSideSortStrategy = SortStrategy.none,
    this.reactions = const [],
  })  : onHideAction = BlockHiddenAction.none,
        extraBroadcastEvents =
            List.unmodifiable(extraBroadcastEvents?.toSet() ?? []);

  /// Creates an immutable copy of this [BlockConfig] with the current configuration values.
  BlockConfig copy() {
    return BlockConfig(
      bindToAncestorPayloadState: bindToAncestorPayloadState,
      unifiedItemRefreshPolicy: unifiedItemRefreshPolicy,
      itemAbsentRepresentativePolicy: itemAbsentRepresentativePolicy,
      preventUnsavedChangesLoss: preventUnsavedChangesLoss,
      enforceParentLinkConstraint: enforceParentLinkConstraint,
      nativeQueryMode: nativeQueryMode,
      pageable: pageable.copy(),
      eventBroadcastEnabled: eventBroadcastEnabled,
      extraBroadcastEvents: extraBroadcastEvents,
      reactions: reactions,
      clientSideSortStrategy: clientSideSortStrategy,
    );
  }
}
