part of '../core.dart';

class _BlockSyncSessionState<ID extends Comparable> extends Equatable
    implements DebugBlockSyncSessionState<ID> {
  @override
  final Block<
      ID, //
      Identifiable<ID>,
      Identifiable<ID>,
      FilterInput,
      FilterCriteria,
      FormInput,
      AdditionalFormRelatedData> block;

  Comparable? _parentBlockItemId;

  @override
  Comparable? get parentBlockItemId => _parentBlockItemId;

  FilterCriteria? _filterCriteria;

  @override
  FilterCriteria? get filterCriteria => _filterCriteria;

  List<BlockReceivedEventInfo<ID>> _receivedEventInfos = [];

  @override
  List<BlockReceivedEventInfo<ID>> get receivedEventInfos =>
      List.unmodifiable(_receivedEventInfos);

  _BlockSyncSessionState({
    required this.block,
    required Comparable? parentItemId,
    required FilterCriteria? filterCriteria,
  })  : _parentBlockItemId = parentItemId,
        _filterCriteria = filterCriteria {
    block.debug._querySessionCount++;
    block.debug._lastViewportSyncStrategy = null;
    block.debug._lastEffectiveItemIds = {};
    block.debug._lastPerformQueryItemIds = {};
  }

  void addReceivedEventInfo({
    required EventSourceType eventSourceType,
    required bool requiresMaxSyncStrategy,
    required BlockViewportSyncStrategy? syncStrategyOnFullQueryMode,
    required BlockViewportSyncStrategy? syncStrategyOnPageableQueryMode,
    required List<Type> mainDataTypes,
    required List<Type> extraDataTypes,
    required List<ID> effectedItemIds,
  }) {
    final eventInfo = BlockReceivedEventInfo<ID>(
      eventSourceType: eventSourceType,
      requiresMaxSyncStrategy: requiresMaxSyncStrategy,
      syncStrategyOnFullQueryMode: syncStrategyOnFullQueryMode,
      syncStrategyOnPageableQueryMode: syncStrategyOnPageableQueryMode,
      dataTypes: mainDataTypes,
      // extraDataTypes: extraDataTypes,
      effectedItemIds: effectedItemIds,
    );
    _receivedEventInfos.add(eventInfo);
  }

  @override
  Set<ID> getEffectedItemIds() {
    Set<ID> set = {};
    for (BlockReceivedEventInfo<ID> info in _receivedEventInfos) {
      set.addAll(info.effectedItemIds);
    }
    return set;
  }

  @override
  Set<ID> getPerformQueryItemIds(List<ID> blockItemIds) {
    final viewportSyncStrategy =
        BlockViewportSyncStrategy.resolveViewportSyncStrategy(
      nativeQueryMode: block.effectiveConfig.nativeQueryMode,
      syncConfig: block.effectiveConfig.viewportSyncConfig,
      receivedEventInfos: _receivedEventInfos,
    );
    //
    switch (viewportSyncStrategy) {
      case null:
      case BlockViewportSyncStrategy.nativeQuery:
        return {};
      case BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery:
        final effectedItemIds = getEffectedItemIds();
        return {...blockItemIds, ...effectedItemIds};
      case BlockViewportSyncStrategy.effectedItemIdsQuery:
        final effectedItemIds = getEffectedItemIds();
        return effectedItemIds;
    }
  }

  /// Evaluates and recalculates the next [BlockDataState] when new events mutate this sync session.
  BlockDataState calculateNextDataState(BlockDataState currentDataState) {
    // 1. Cold baseline states remain unaffected by external incoming events
    if (currentDataState.isNone || currentDataState.isPending) {
      return currentDataState;
    }

    // 2. If already STALE, preserve the stale state
    if (currentDataState.isStale) {
      return currentDataState;
    }

    // 3. If currently FRESH, mark as STALE due to incoming event invalidation
    if (currentDataState.isFresh) {
      final isFromInternalShelf = _receivedEventInfos.any(
        (info) => info.eventSourceType == EventSourceType.internal,
      );

      return BlockDataStateLoadedStale(
        reason: BlockLoadedStateStaleReasonEvent(),
      );
    }

    return currentDataState;
  }

  @override
  List<Object?> get props {
    return [
      parentBlockItemId,
      filterCriteria,
      // __viewportSyncStrategy,
      ...getEffectedItemIds()
    ];
  }

  @override
  String toString() {
    return "parentItemId: $parentBlockItemId, filterCriteria: ${filterCriteria == null ? 'null' : 'OK'}";
  }
}
