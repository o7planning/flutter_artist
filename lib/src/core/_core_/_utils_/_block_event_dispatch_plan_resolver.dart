part of '../core.dart';

/// Pure mathematical and architectural resolver determining event compatibility,
/// projection hierarchy alignments, and synchronization escalation boundaries.
class BlockEventDispatchPlanResolver {
  /// Resolves the comprehensive event dispatching plan for an observing listener block.
  ///
  /// ### Architectural Principles:
  /// 1. **Projection Family Awareness**: Source and listener entities are verified against
  ///    declared [ProjectionFamily] groups to ensure IDs are shared within the same domain.
  /// 2. **Strictest Strategy Wins (Escalation Rule)**: If a listener reacts to both a primary
  ///    entity event (which carries IDs) and an auxiliary/extra event (which lacks entity IDs),
  ///    the entire dispatch plan escalates to [requiresMaxSyncStrategy].
  /// 3. **ID Space Isolation**: When crossing entity boundaries (e.g., Parent reacting to Child
  ///    events of a different type), source IDs are stripped to prevent invalid ID lookups.
  static BlockEventDispatchPlan<ID> resolvePlan<ID extends Comparable>({
    // 1. Source Block Event Footprint (Producer)
    required Set<Type> eventMainResolvedTypes,
    required Set<Type> eventExtraResolvedTypes,
    required List<ID> sourceEffectedItemIds,

    // 2. Target Block Configuration (Consumer)
    required Set<Type> listenerTargetTypes,
    required Set<Type> listenerReactionTypes,
  }) {
    // =========================================================================
    // 1. EVALUATE REACTION MATCHES ACROSS BOTH BRANCHES
    // =========================================================================
    final bool matchMain = DataTypeEventUtils.hasIntersection(
      eventMainResolvedTypes,
      listenerReactionTypes,
    );

    final bool matchExtra = DataTypeEventUtils.hasIntersection(
      eventExtraResolvedTypes,
      listenerReactionTypes,
    );

    // Short-circuit: The listener does not observe any emitted event types.
    if (!matchMain && !matchExtra) {
      return const BlockEventDispatchPlan.ignore();
    }

    // =========================================================================
    // 2. DOMAIN FAMILY ALIGNMENT CHECK
    // =========================================================================
    // The main event branch is only safe for direct ID propagation if the listener
    // exposes a core data type within the same domain family.
    final bool isMainSameDomain = matchMain &&
        DataTypeEventUtils.hasIntersection(
          eventMainResolvedTypes,
          listenerTargetTypes,
        );

    // =========================================================================
    // 3. STRATEGY ESCALATION (MAX STRATEGY ENFORCEMENT)
    // =========================================================================
    // Escalate to MAX STRATEGY if:
    // a. An extra event was matched (which has no valid target entity ID space).
    // b. A main event was matched, but the listener belongs to a different domain family.
    final bool mustEscalateToMax =
        matchExtra || (matchMain && !isMainSameDomain);

    if (mustEscalateToMax) {
      return BlockEventDispatchPlan<ID>(
        shouldDispatch: true,
        isSameDomainFamily: isMainSameDomain && !matchExtra,
        effectiveItemIds:
        null, // Strip IDs to prevent cross-entity query pollution.
        requiresMaxSyncStrategy: true,
      );
    }

    // =========================================================================
    // 4. UNIFORM DOMAIN DISPATCH (TARGETED ID QUERY ALLOWED)
    // =========================================================================
    return BlockEventDispatchPlan<ID>(
      shouldDispatch: true,
      isSameDomainFamily: true,
      effectiveItemIds:
      sourceEffectedItemIds.isNotEmpty ? sourceEffectedItemIds : null,
      requiresMaxSyncStrategy: false,
    );
  }
}
