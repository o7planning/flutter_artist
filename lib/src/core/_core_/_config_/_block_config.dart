part of '../core.dart';

class BlockConfig {
  final bool leaveTheFormSafely;
  final BlockRefreshItemMode refreshItemMode;
  final BlockHiddenBehavior hiddenBehavior;

  final BlockOutsideBroadcast? outsideBroadcast;

  final BlockOutsideEventReaction? outsideEventReaction;

  final PageableData pageable;

  final List<Evt>? refreshCurrItemByInternalShelfEvents;
  final List<Evt>? reQueryByInternalShelfEvents;

  BlockConfig({
    this.refreshItemMode = BlockRefreshItemMode.auto,
    this.leaveTheFormSafely = true,
    this.hiddenBehavior = BlockHiddenBehavior.none,
    this.outsideBroadcast,
    this.outsideEventReaction,
    this.refreshCurrItemByInternalShelfEvents,
    this.reQueryByInternalShelfEvents,
    this.pageable = const PageableData(
      page: 1,
      pageSize: 20,
    ),
  });

  BlockConfig copy() {
    return BlockConfig(
      refreshItemMode: refreshItemMode,
      leaveTheFormSafely: leaveTheFormSafely,
      hiddenBehavior: hiddenBehavior,
      outsideBroadcast: outsideBroadcast,
      outsideEventReaction: outsideEventReaction,
      refreshCurrItemByInternalShelfEvents:
          refreshCurrItemByInternalShelfEvents,
      reQueryByInternalShelfEvents: reQueryByInternalShelfEvents,
      pageable: pageable.copy(),
    );
  }
}
