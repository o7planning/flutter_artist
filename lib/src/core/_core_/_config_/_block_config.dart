part of '../core.dart';

class BlockConfig {
  final bool preventUnsavedChangesLoss;
  final ItemAbsentRepresentativePolicy itemAbsentRepresentativePolicy;
  final UnifiedItemRefreshPolicy unifiedItemRefreshPolicy;
  final BlockHiddenAction onHideAction;

  final Pageable pageable;

  ///
  final List<Event> emitExternalShelfEvents;

  ///
  /// Reaction to External Events. Docs: 14769/27a
  ///
  final ExternalShelfEventBlockRecipient onExternalShelfEvents;

  final InternalShelfEventBlockRecipient onInternalShelfEvents;

  final SortStrategy clientSideSortStrategy;

  BlockConfig({
    this.itemAbsentRepresentativePolicy =
        ItemAbsentRepresentativePolicy.tryNotSetAnItemAsCurrent,
    this.unifiedItemRefreshPolicy = UnifiedItemRefreshPolicy.auto,
    this.preventUnsavedChangesLoss = true,
    this.onHideAction = BlockHiddenAction.none,
    List<Event>? emitExternalShelfEvents,
    //
    List<Event>? executeItemLevelReactionToEvents,
    this.onExternalShelfEvents = const ExternalShelfEventBlockRecipient(
      blockLevelReactionOn: [],
    ),
    this.onInternalShelfEvents = const InternalShelfEventBlockRecipient(
      blockLevelReactionOn: [],
      itemLevelReactionOn: [],
    ),
    //
    this.pageable = const Pageable(
      page: 1,
      pageSize: 20,
    ),
    this.clientSideSortStrategy = SortStrategy.none,
  }) : emitExternalShelfEvents =
            List.unmodifiable(emitExternalShelfEvents?.toSet() ?? []);

  BlockConfig copy() {
    return BlockConfig(
      unifiedItemRefreshPolicy: unifiedItemRefreshPolicy,
      itemAbsentRepresentativePolicy: itemAbsentRepresentativePolicy,
      preventUnsavedChangesLoss: preventUnsavedChangesLoss,
      onHideAction: onHideAction,
      pageable: pageable.copy(),
      //
      emitExternalShelfEvents: emitExternalShelfEvents,
      //
      onExternalShelfEvents: onExternalShelfEvents,
      onInternalShelfEvents: onInternalShelfEvents,
      //
      clientSideSortStrategy: clientSideSortStrategy,
    );
  }
}
