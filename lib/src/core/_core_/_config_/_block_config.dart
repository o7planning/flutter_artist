part of '../core.dart';

class BlockConfig {
  final bool enforceParentLinkConstraint;
  final bool preventUnsavedChangesLoss;

  @Deprecated("No longer supported")
  final ItemAbsentRepresentativePolicy itemAbsentRepresentativePolicy;

  // IdentityBlockConfig
  @Deprecated("No longer supported")
  final UnifiedItemRefreshPolicy unifiedItemRefreshPolicy;
  final BlockHiddenAction onHideAction;

  final bool isNativeQueryModeLocked;
  final BlockNativeQueryMode nativeQueryMode;
  final Pageable pageable;

  ///
  // final List<Type> broadcastExternalShelfEvents;

  final bool eventBroadcastEnabled;

  final List<Type> extraBroadcastEvents;

  final SortStrategy clientSideSortStrategy;

  final BlockViewportSyncConfig viewportSyncConfig;

  /// Unified event recipient configuration.
  /// No more separation between internal and external configuration blocks.
  ///
  /// Docs: 14769/27a
  final List<BlockEventReaction> reactions;

  BlockConfig({
    this.enforceParentLinkConstraint = false,
    this.itemAbsentRepresentativePolicy =
        ItemAbsentRepresentativePolicy.tryNotSetAnItemAsCurrent,
    this.unifiedItemRefreshPolicy = UnifiedItemRefreshPolicy.auto,
    this.preventUnsavedChangesLoss = true,
    this.viewportSyncConfig = const BlockViewportSyncConfig(),
    // List<Type>? broadcastExternalShelfEvents,
    this.eventBroadcastEnabled = false,
    List<Type>? extraBroadcastEvents,
    //
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

  BlockConfig copy() {
    return BlockConfig(
      unifiedItemRefreshPolicy: unifiedItemRefreshPolicy,
      itemAbsentRepresentativePolicy: itemAbsentRepresentativePolicy,
      preventUnsavedChangesLoss: preventUnsavedChangesLoss,
      enforceParentLinkConstraint: enforceParentLinkConstraint,
      nativeQueryMode: nativeQueryMode,
      pageable: pageable.copy(),
      //
      eventBroadcastEnabled: eventBroadcastEnabled,
      extraBroadcastEvents: extraBroadcastEvents,
      //
      reactions: reactions,
      //
      clientSideSortStrategy: clientSideSortStrategy,
    );
  }
}
