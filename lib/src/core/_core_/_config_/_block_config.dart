part of '../core.dart';

class BlockConfig {
  final bool leaveTheFormSafely;
  final ItemAbsentRepresentativePolicy itemAbsentRepresentativePolicy;
  final UniformItemRefreshPolicy uniformItemRefreshPolicy;
  final BlockHiddenAction onHideAction;

  final Pageable pageable;

  ///
  final List<Event> fireExternalShelfEvents;

  ///
  /// Reaction to External Events. Docs: 14769/27a
  ///
  final ExternalShelfEventB onExternalShelfEvents;

  final InternalShelfEventB onInternalShelfEvents;

  final ClientSideSortMode clientSideSortMode;

  BlockConfig({
    this.itemAbsentRepresentativePolicy =
        ItemAbsentRepresentativePolicy.tryNotSetAnItemAsCurrent,
    this.uniformItemRefreshPolicy = UniformItemRefreshPolicy.auto,
    this.leaveTheFormSafely = true,
    this.onHideAction = BlockHiddenAction.none,
    List<Event>? fireExternalShelfEvents,
    //
    List<Event>? executeItemLevelReactionToEvents,
    this.onExternalShelfEvents = const ExternalShelfEventB(
      blockLevelReactionTo: [],
    ),
    this.onInternalShelfEvents = const InternalShelfEventB(
      blockLevelReactionTo: [],
      itemLevelReactionTo: [],
    ),
    //
    this.pageable = const Pageable(
      page: 1,
      pageSize: 20,
    ),
    this.clientSideSortMode = ClientSideSortMode.none,
  }) : fireExternalShelfEvents =
            List.unmodifiable(fireExternalShelfEvents?.toSet() ?? []);

  BlockConfig copy() {
    return BlockConfig(
      uniformItemRefreshPolicy: uniformItemRefreshPolicy,
      itemAbsentRepresentativePolicy: itemAbsentRepresentativePolicy,
      leaveTheFormSafely: leaveTheFormSafely,
      onHideAction: onHideAction,
      pageable: pageable.copy(),
      //
      fireExternalShelfEvents: fireExternalShelfEvents,
      //
      onExternalShelfEvents: onExternalShelfEvents,
      onInternalShelfEvents: onInternalShelfEvents,
      //
      clientSideSortMode: clientSideSortMode,
    );
  }
}
