part of '../core.dart';

class BlockConfig {
  final bool leaveTheFormSafely;
  final BlockRefreshItemMode refreshItemMode;
  final BlockHiddenBehavior hiddenBehavior;

  final PageableData pageable;

  //

  // @Deprecated("Xoa di")
  // final BlockOutsideEventReaction? outsideEventReaction;

  //

  final List<Type>? outsideBroadcastEvents;

  final List<Type>? refreshCurrItemByExternalShelfEvents;
  final List<Type>? reQueryByExternalShelfEvents;

  final List<Evt>? refreshCurrItemByInternalShelfEvents;
  final List<Evt>? reQueryByInternalShelfEvents;

  BlockConfig({
    this.refreshItemMode = BlockRefreshItemMode.auto,
    this.leaveTheFormSafely = true,
    this.hiddenBehavior = BlockHiddenBehavior.none,
    // this.outsideEventReaction,
    this.outsideBroadcastEvents,
    //
    this.refreshCurrItemByExternalShelfEvents,
    this.reQueryByExternalShelfEvents,
    //
    this.refreshCurrItemByInternalShelfEvents,
    this.reQueryByInternalShelfEvents,
    //
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
      pageable: pageable.copy(),
      //
      // outsideEventReaction: outsideEventReaction,
      //
      outsideBroadcastEvents: outsideBroadcastEvents,
      refreshCurrItemByInternalShelfEvents:
          refreshCurrItemByInternalShelfEvents,
      reQueryByInternalShelfEvents: reQueryByInternalShelfEvents,
      //
      refreshCurrItemByExternalShelfEvents:
          refreshCurrItemByExternalShelfEvents,
      reQueryByExternalShelfEvents: reQueryByExternalShelfEvents,
    );
  }
}
