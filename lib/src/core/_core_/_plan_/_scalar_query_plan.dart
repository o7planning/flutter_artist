part of '../core.dart';

/// Result object holding the resolved query strategy and target item IDs.
class ScalarQueryPlan<ID extends Comparable> {
  final ScalarResolvedQueryAction? action;

  const ScalarQueryPlan({
    required this.action,
  });

  const ScalarQueryPlan.none() : action = null;
}
