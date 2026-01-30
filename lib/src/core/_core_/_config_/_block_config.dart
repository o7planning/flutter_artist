part of '../core.dart';

class BlockConfig {
  final bool leaveTheFormSafely;
  final NonItemRepresentativeBehavior nonItemRepresentativeBehavior;
  final UniformItemRefreshMode uniformItemRefreshMode;
  final BlockHiddenBehavior hiddenBehavior;

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
    this.nonItemRepresentativeBehavior =
        NonItemRepresentativeBehavior.tryNotSetAnItemAsCurrent,
    this.uniformItemRefreshMode = UniformItemRefreshMode.auto,
    this.leaveTheFormSafely = true,
    this.hiddenBehavior = BlockHiddenBehavior.none,
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
      uniformItemRefreshMode: uniformItemRefreshMode,
      nonItemRepresentativeBehavior: nonItemRepresentativeBehavior,
      leaveTheFormSafely: leaveTheFormSafely,
      hiddenBehavior: hiddenBehavior,
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
