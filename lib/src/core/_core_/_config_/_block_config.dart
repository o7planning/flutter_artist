part of '../core.dart';

class BlockConfig {
  final bool leaveTheFormSafely;
  final NonItemRepresentativeBehavior nonItemRepresentativeBehavior;
  final UniformItemRefreshMode uniformItemRefreshMode;
  final BlockHiddenBehavior hiddenBehavior;

  final Pageable pageable;

  //
  final bool selfReQueryable;
  final bool currentItemSelfRefreshable;

  final List<Event> outsideBroadcastEvents;

  ///
  /// Reaction to External Events.
  ///
  // final List<Event> executeItemLevelReactionToEvents;

  ///
  /// Reaction to External Events. Docs: 14769/27a
  ///
  final List<Event> executeBlockLevelReactionToEvents;

  ///
  /// Reaction to Internal Events.
  ///
  final List<Evt> executeItemLevelReactionToEvts;

  ///
  /// Reaction to Internal Events.
  ///
  final List<Evt> executeBlockLevelReactionToEvts;

  final ClientSideSortMode clientSideSortMode;

  BlockConfig({
    this.nonItemRepresentativeBehavior =
        NonItemRepresentativeBehavior.tryNotSetAnItemAsCurrent,
    this.uniformItemRefreshMode = UniformItemRefreshMode.auto,
    this.leaveTheFormSafely = true,
    this.hiddenBehavior = BlockHiddenBehavior.none,
    List<Event>? outsideBroadcastEvents,
    //
    List<Event>? executeItemLevelReactionToEvents,
    List<Event>? executeBlockLevelReactionToEvents,
    //
    this.selfReQueryable = false,
    this.currentItemSelfRefreshable = false,
    List<Evt>? executeItemLevelReactionToEvts,
    List<Evt>? executeBlockLevelReactionToEvts,
    //
    this.pageable = const Pageable(
      page: 1,
      pageSize: 20,
    ),
    this.clientSideSortMode = ClientSideSortMode.none,
  })  : outsideBroadcastEvents =
            List.unmodifiable(outsideBroadcastEvents?.toSet() ?? []),
        // executeItemLevelReactionToEvents = //
        //     List.unmodifiable(executeItemLevelReactionToEvents?.toSet() ?? []),
        executeBlockLevelReactionToEvents =
            List.unmodifiable(executeBlockLevelReactionToEvents?.toSet() ?? []),
        executeItemLevelReactionToEvts = //
            List.unmodifiable(executeItemLevelReactionToEvts?.toSet() ?? []),
        executeBlockLevelReactionToEvts =
            List.unmodifiable(executeBlockLevelReactionToEvts?.toSet() ?? []);

  BlockConfig copy() {
    return BlockConfig(
      uniformItemRefreshMode: uniformItemRefreshMode,
      nonItemRepresentativeBehavior: nonItemRepresentativeBehavior,
      leaveTheFormSafely: leaveTheFormSafely,
      hiddenBehavior: hiddenBehavior,
      pageable: pageable.copy(),
      //
      selfReQueryable: selfReQueryable,
      outsideBroadcastEvents: outsideBroadcastEvents,
      //
      currentItemSelfRefreshable: currentItemSelfRefreshable,
      executeItemLevelReactionToEvts: executeItemLevelReactionToEvts,
      executeBlockLevelReactionToEvts: executeBlockLevelReactionToEvts,
      //
      // executeItemLevelReactionToEvents: executeItemLevelReactionToEvents,
      executeBlockLevelReactionToEvents: executeBlockLevelReactionToEvents,
      //
      clientSideSortMode: clientSideSortMode,
    );
  }
}
