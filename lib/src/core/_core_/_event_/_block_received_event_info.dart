part of '../core.dart';

class BlockReceivedEventInfo<ID extends Comparable> {
  final EventSourceType eventSourceType;
  final BlockViewportSyncStrategy? syncStrategyOnFullQueryMode;
  final BlockViewportSyncStrategy? syncStrategyOnPageableQueryMode;
  final List<Type> dataTypes;
  final List<ID> effectedItemIds;
  final bool requiresMaxSyncStrategy;

  BlockReceivedEventInfo({
    required this.eventSourceType,
    required this.syncStrategyOnFullQueryMode,
    required this.syncStrategyOnPageableQueryMode,
    required this.dataTypes,
    required this.effectedItemIds,
    required this.requiresMaxSyncStrategy,
  });

  BlockReceivedEventInfo.maxSyncStrategy({
    required this.eventSourceType,
    required this.dataTypes,
  })
      : requiresMaxSyncStrategy = true,
        effectedItemIds = [],
        syncStrategyOnFullQueryMode = BlockViewportSyncStrategy.nativeQuery,
        syncStrategyOnPageableQueryMode =
            BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery;
}
