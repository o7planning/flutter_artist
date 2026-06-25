part of '../core.dart';

class _DebugBlockRequeryCondition<ID extends Object> {
  Set<ID> _lastEffectiveItemIds = {};

  Set<ID> get lastEffectiveItemIds => _lastEffectiveItemIds;

  Set<ID> _lastPerformQueryItemIds = {};

  Set<ID> get lastPerformQueryItemIds => _lastPerformQueryItemIds;

  BlockViewportSyncStrategy? _lastViewportSyncStrategy;

  BlockViewportSyncStrategy? get lastViewportSyncStrategy =>
      _lastViewportSyncStrategy;

  int _transactionCount = 0;

  int get transactionCount => _transactionCount;

  int _viewportSyncStrategyChangeCount = 0;

  int get viewportSyncStrategyChangeCount => _viewportSyncStrategyChangeCount;
}
