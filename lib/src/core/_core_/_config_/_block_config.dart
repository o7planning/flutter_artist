part of '../core.dart';

class BlockConfig {
  final bool leaveTheFormSafely;
  final BlockItemRefreshmentMode itemRefreshmentMode;
  final BlockHiddenBehavior hiddenBehavior;

  final PageableData pageable;

  //

  final List<Type> outsideBroadcastEvents;

  final List<Type>? refreshCurrItemByExternalShelfEvents;
  final List<Type>? reQueryByExternalShelfEvents;

  final List<Evt>? refreshCurrItemByInternalShelfEvents;
  final List<Evt>? reQueryByInternalShelfEvents;

  BlockConfig({
    this.itemRefreshmentMode = BlockItemRefreshmentMode.auto,
    this.leaveTheFormSafely = true,
    this.hiddenBehavior = BlockHiddenBehavior.none,
    List<Type>? outsideBroadcastEvents,
    //
    List<Type>? refreshCurrItemByExternalShelfEvents,
    List<Type>? reQueryByExternalShelfEvents,
    //
    List<Evt>? refreshCurrItemByInternalShelfEvents,
    List<Evt>? reQueryByInternalShelfEvents,
    //
    this.pageable = const PageableData(
      page: 1,
      pageSize: 20,
    ),
  })  : outsideBroadcastEvents =
            List.unmodifiable(outsideBroadcastEvents ?? []),
        refreshCurrItemByExternalShelfEvents =
            List.unmodifiable(refreshCurrItemByExternalShelfEvents ?? []),
        reQueryByExternalShelfEvents =
            List.unmodifiable(reQueryByExternalShelfEvents ?? []),
        refreshCurrItemByInternalShelfEvents =
            List.unmodifiable(refreshCurrItemByInternalShelfEvents ?? []),
        reQueryByInternalShelfEvents =
            List.unmodifiable(reQueryByInternalShelfEvents ?? []);

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
      refreshCurrItemByExternalShelfEvents:
          refreshCurrItemByExternalShelfEvents,
      reQueryByExternalShelfEvents: reQueryByExternalShelfEvents,
    );
  }
}
