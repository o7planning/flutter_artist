part of '../core.dart';

/// Encapsulates the resolved strategy and payload constraints for dispatching
/// an event batch from a mutating source block to an observing target block.
class BlockEventDispatchPlan<ID extends Comparable> {
  /// Indicates whether the target block observes any data types emitted in this event cycle.
  final bool shouldDispatch;

  /// Indicates whether all matched reactions strictly belong to the same domain entity family
  /// (resolved via [ProjectionFamily]) without any external or auxiliary data triggers.
  final bool isSameDomainFamily;

  /// A filtered list of entity IDs that can be safely consumed by the target block.
  ///
  /// This evaluates to `null` if the plan escalates to [requiresMaxSyncStrategy],
  /// preventing ID space pollution across disparate entity types.
  final List<ID>? effectiveItemIds;

  /// Commands the target block to enforce maximum viewport synchronization
  /// (`nativeQuery` for full-query mode, or `effectedAndViewportItemIdsQuery` for pageable mode).
  ///
  /// This escalates to `true` whenever auxiliary extra events are triggered, or when
  /// the source and target blocks do not share the same domain entity family.
  final bool requiresMaxSyncStrategy;

  const BlockEventDispatchPlan({
    required this.shouldDispatch,
    required this.isSameDomainFamily,
    required this.effectiveItemIds,
    required this.requiresMaxSyncStrategy,
  });

  /// Factory constructor representing a complete no-op plan when no reactions match.
  const BlockEventDispatchPlan.ignore()
      : shouldDispatch = false,
        isSameDomainFamily = false,
        effectiveItemIds = null,
        requiresMaxSyncStrategy = false;
}
