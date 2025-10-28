part of '../core.dart';

class BlockConfig {
  final bool leaveTheFormSafely;
  final BlockItemRefreshmentMode itemRefreshmentMode;
  final BlockHiddenBehavior hiddenBehavior;

  final Pageable pageable;

  //
  final bool selfReQueryable;
  final bool currentItemSelfRefreshable;

  final List<Event> outsideBroadcastEvents;

  ///
  /// Reaction to External Events.
  ///
  final List<Event> executeItemLevelReactionToEvents;

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
    this.itemRefreshmentMode = BlockItemRefreshmentMode.auto,
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
        executeItemLevelReactionToEvents = //
            List.unmodifiable(executeItemLevelReactionToEvents?.toSet() ?? []),
        executeBlockLevelReactionToEvents =
            List.unmodifiable(executeBlockLevelReactionToEvents?.toSet() ?? []),
        executeItemLevelReactionToEvts = //
            List.unmodifiable(executeItemLevelReactionToEvts?.toSet() ?? []),
        executeBlockLevelReactionToEvts =
            List.unmodifiable(executeBlockLevelReactionToEvts?.toSet() ?? []);

  BlockConfig copy() {
    return BlockConfig(
      itemRefreshmentMode: itemRefreshmentMode,
      leaveTheFormSafely: leaveTheFormSafely,
      hiddenBehavior: hiddenBehavior,
      pageable: pageable.copy(),
      //
      outsideBroadcastEvents: outsideBroadcastEvents,
      executeItemLevelReactionToEvts: executeItemLevelReactionToEvts,
      executeBlockLevelReactionToEvts: executeBlockLevelReactionToEvts,
      //
      selfReQueryable: selfReQueryable,
      currentItemSelfRefreshable: currentItemSelfRefreshable,
      executeItemLevelReactionToEvents: executeItemLevelReactionToEvents,
      executeBlockLevelReactionToEvents: executeBlockLevelReactionToEvents,
      //
      clientSideSortMode: clientSideSortMode,
    );
  }
}
