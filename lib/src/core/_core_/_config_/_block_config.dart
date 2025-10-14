part of '../core.dart';

class BlockConfig {
  final bool leaveTheFormSafely;
  final BlockItemRefreshmentMode itemRefreshmentMode;
  final BlockHiddenBehavior hiddenBehavior;

  final PageableData pageable;

  //
  final bool selfReQueryable;
  final bool currentItemSelfRefreshable;

  final List<Event> outsideBroadcastEvents;

  final List<Event> refreshCurrItemByExternalShelfEvents;

  // Docs: 14769/27a
  final List<Event> reQueryByExternalShelfEvents;

  final List<Evt> refreshCurrItemByInternalShelfEvents;
  final List<Evt> reQueryByInternalShelfEvents;

  BlockConfig({
    this.itemRefreshmentMode = BlockItemRefreshmentMode.auto,
    this.leaveTheFormSafely = true,
    this.hiddenBehavior = BlockHiddenBehavior.none,
    List<Event>? outsideBroadcastEvents,
    //
    List<Event>? refreshCurrItemByExternalShelfEvents,
    List<Event>? reQueryByExternalShelfEvents,
    //
    this.selfReQueryable = false,
    this.currentItemSelfRefreshable = false,
    List<Evt>? refreshCurrItemByInternalShelfEvents,
    List<Evt>? reQueryByInternalShelfEvents,
    //
    this.pageable = const PageableData(
      page: 1,
      pageSize: 20,
    ),
  })  : outsideBroadcastEvents =
            List.unmodifiable(outsideBroadcastEvents?.toSet() ?? []),
        refreshCurrItemByExternalShelfEvents = //
            List.unmodifiable(
                refreshCurrItemByExternalShelfEvents?.toSet() ?? []),
        reQueryByExternalShelfEvents =
            List.unmodifiable(reQueryByExternalShelfEvents?.toSet() ?? []),
        refreshCurrItemByInternalShelfEvents = //
            List.unmodifiable(
                refreshCurrItemByInternalShelfEvents?.toSet() ?? []),
        reQueryByInternalShelfEvents =
            List.unmodifiable(reQueryByInternalShelfEvents?.toSet() ?? []);

  BlockConfig copy() {
    return BlockConfig(
      itemRefreshmentMode: itemRefreshmentMode,
      leaveTheFormSafely: leaveTheFormSafely,
      hiddenBehavior: hiddenBehavior,
      pageable: pageable.copy(),
      //
      outsideBroadcastEvents: outsideBroadcastEvents,
      refreshCurrItemByInternalShelfEvents:
          refreshCurrItemByInternalShelfEvents,
      reQueryByInternalShelfEvents: reQueryByInternalShelfEvents,
      //
      selfReQueryable: selfReQueryable,
      currentItemSelfRefreshable: currentItemSelfRefreshable,
      refreshCurrItemByExternalShelfEvents:
          refreshCurrItemByExternalShelfEvents,
      reQueryByExternalShelfEvents: reQueryByExternalShelfEvents,
    );
  }
}
