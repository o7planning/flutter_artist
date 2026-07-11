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

  final Pageable pageable;

  ///
  final List<Type> broadcastExternalShelfEvents;

  final SortStrategy clientSideSortStrategy;

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
    List<Type>? broadcastExternalShelfEvents,
    //
    this.pageable = const Pageable(
      page: 1,
      pageSize: 20,
    ),
    this.clientSideSortStrategy = SortStrategy.none,
    this.reactions = const [],
  })  : this.onHideAction = BlockHiddenAction.none,
        broadcastExternalShelfEvents =
            List.unmodifiable(broadcastExternalShelfEvents?.toSet() ?? []);

  BlockConfig copy() {
    return BlockConfig(
      unifiedItemRefreshPolicy: unifiedItemRefreshPolicy,
      itemAbsentRepresentativePolicy: itemAbsentRepresentativePolicy,
      preventUnsavedChangesLoss: preventUnsavedChangesLoss,
      enforceParentLinkConstraint: enforceParentLinkConstraint,
      // onHideAction: onHideAction,
      pageable: pageable.copy(),
      //
      broadcastExternalShelfEvents: broadcastExternalShelfEvents,
      //
      reactions: reactions,
      //
      clientSideSortStrategy: clientSideSortStrategy,
    );
  }
}
