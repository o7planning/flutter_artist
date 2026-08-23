part of '../core.dart';

/// Result object holding the resolved query strategy and target item IDs.
class BlockQueryPlan<ID extends Comparable> {
  /// The resolved action to be executed by the Block runner.
  final BlockResolvedQueryAction? action;

  /// The resolved viewport synchronization strategy.
  final BlockViewportSyncStrategy? viewportSyncStrategy;

  /// Target item IDs to be queried when [action] is [BlockResolvedQueryAction.performQueryByItemIds].
  final Set<ID> targetItemIds;

  const BlockQueryPlan({
    required this.action,
    this.viewportSyncStrategy,
    this.targetItemIds = const {},
  });

  const BlockQueryPlan.none()
      : action = null,
        viewportSyncStrategy = null,
        targetItemIds = const {};
}

/// Result object holding the resolved query strategy and target item IDs.
class ScalarQueryPlan<ID extends Comparable> { 
  final ScalarResolvedQueryAction? action;

  const ScalarQueryPlan({
    required this.action,
  });

  const ScalarQueryPlan.none() : action = null;
}
