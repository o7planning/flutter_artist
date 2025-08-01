part of '../core.dart';

class BlockConfig {
  final bool leaveTheFormSafely;
  final BlockRefreshItemMode refreshItemMode;
  final BlockHiddenBehavior hiddenBehavior;

  final BlockOutsideBroadcast? outsideBroadcast;

  final BlockOutsideEventReaction? outsideEventReaction;

  final PageableData pageable;

  BlockConfig({
    this.refreshItemMode = BlockRefreshItemMode.auto,
    this.leaveTheFormSafely = true,
    this.hiddenBehavior = BlockHiddenBehavior.none,
    this.outsideBroadcast,
    this.outsideEventReaction,
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
      pageable: pageable.copy(),
    );
  }
}
