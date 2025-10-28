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
  final List<Event> itemLevelReactionToEvents;

  // Docs: 14769/27a
  final List<Event> blockLevelReactionToEvents;

  final List<Evt> itemLevelReactionToEvts;
  final List<Evt> blockLevelReactionToEvts;

  final ClientSideSortMode clientSideSortMode;

  BlockConfig({
    this.itemRefreshmentMode = BlockItemRefreshmentMode.auto,
    this.leaveTheFormSafely = true,
    this.hiddenBehavior = BlockHiddenBehavior.none,
    List<Event>? outsideBroadcastEvents,
    //
    List<Event>? itemLevelReactionToEvents,
    List<Event>? blockLevelReactionToEvents,
    //
    this.selfReQueryable = false,
    this.currentItemSelfRefreshable = false,
    List<Evt>? itemLevelReactionToEvts,
    List<Evt>? blockLevelReactionToEvts,
    //
    this.pageable = const Pageable(
      page: 1,
      pageSize: 20,
    ),
    this.clientSideSortMode = ClientSideSortMode.none,
  })  : outsideBroadcastEvents =
            List.unmodifiable(outsideBroadcastEvents?.toSet() ?? []),
        itemLevelReactionToEvents = //
            List.unmodifiable(
                itemLevelReactionToEvents?.toSet() ?? []),
        blockLevelReactionToEvents =
            List.unmodifiable(blockLevelReactionToEvents?.toSet() ?? []),
        itemLevelReactionToEvts = //
            List.unmodifiable(
                itemLevelReactionToEvts?.toSet() ?? []),
        blockLevelReactionToEvts =
            List.unmodifiable(blockLevelReactionToEvts?.toSet() ?? []);

  BlockConfig copy() {
    return BlockConfig(
      itemRefreshmentMode: itemRefreshmentMode,
      leaveTheFormSafely: leaveTheFormSafely,
      hiddenBehavior: hiddenBehavior,
      pageable: pageable.copy(),
      //
      outsideBroadcastEvents: outsideBroadcastEvents,
      itemLevelReactionToEvts:
          itemLevelReactionToEvts,
      blockLevelReactionToEvts: blockLevelReactionToEvts,
      //
      selfReQueryable: selfReQueryable,
      currentItemSelfRefreshable: currentItemSelfRefreshable,
      itemLevelReactionToEvents:
          itemLevelReactionToEvents,
      blockLevelReactionToEvents: blockLevelReactionToEvents,
      //
      clientSideSortMode: clientSideSortMode,
    );
  }
}
