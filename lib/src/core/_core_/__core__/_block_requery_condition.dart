part of '../core.dart';

class _BlockRequeryCondition<ID extends Object> extends Equatable {
  final Block<ID, Identifiable<ID>, Identifiable<ID>, FilterInput,
      FilterCriteria, FormInput, AdditionalFormRelatedData> _block;
  Object? _parentItemId;

  @override
  Object? get parentItemId => _parentItemId;

  FilterCriteria? _filterCriteria;

  @override
  FilterCriteria? get filterCriteria => _filterCriteria;

  // IMPORTANT: Initial null, do not change!
  BlockViewportSyncStrategy? __viewportSyncStrategy;

  @override
  BlockViewportSyncStrategy? get viewportSyncStrategy => __viewportSyncStrategy;

  Set<ID> __effectiveItemIds = {};

  @override
  Set<ID> get effectiveItemIds => __effectiveItemIds;

  _BlockRequeryCondition({
    required Block<
            ID, //
            Identifiable<ID>,
            Identifiable<ID>,
            FilterInput,
            FilterCriteria,
            FormInput,
            AdditionalFormRelatedData>
        block,
    required Object? parentItemId,
    required FilterCriteria? filterCriteria,
  })  : _block = block,
        _parentItemId = parentItemId,
        _filterCriteria = filterCriteria {
    _block.debug.requeryCondition._transactionCount++;
    _block.debug.requeryCondition._lastViewportSyncStrategy = null;
    _block.debug.requeryCondition._lastEffectiveItemIds = {};
    _block.debug.requeryCondition._lastPerformQueryItemIds = {};
  }

  void addEffectiveItemIds({
    required BlockViewportSyncStrategy? viewportSyncStrategy,
    required List<ID> effectiveItemIds,
  }) {
    if (__viewportSyncStrategy != viewportSyncStrategy) {
      _block.debug.requeryCondition._viewportSyncStrategyChangeCount++;
      _block.debug.requeryCondition._lastViewportSyncStrategy =
          viewportSyncStrategy;
      __viewportSyncStrategy = viewportSyncStrategy;
    }
    __effectiveItemIds.addAll(effectiveItemIds);
    _block.debug.requeryCondition._lastEffectiveItemIds
        .addAll(effectiveItemIds);
  }

  Set<ID> getPerformQueryItemIds(List<ID> blockItemIds) {
    switch (viewportSyncStrategy) {
      case null:
      case BlockViewportSyncStrategy.forceNativeQuery:
        return {};
      case BlockViewportSyncStrategy.convergeAll:
        return {...blockItemIds, ...__effectiveItemIds};
      case BlockViewportSyncStrategy.incrementalMerge:
        return {...__effectiveItemIds};
    }
  }

  @override
  List<Object?> get props => [
        parentItemId,
        filterCriteria,
        __viewportSyncStrategy,
        ...(__effectiveItemIds ?? [])
      ];

  @override
  String toString() {
    return "parentItemId: $parentItemId, filterCriteria: ${filterCriteria == null ? 'null' : 'OK'}, viewportSyncStrategy: $__viewportSyncStrategy";
  }
}
