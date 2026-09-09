part of '../core.dart';

/// Rationale behind why an item was evicted from in-memory collection.
enum ItemEvictionReason {
  /// Explicitly deleted via user or caller action.
  userDeleted,

  /// Entity was removed or not found on the remote backend during verification/fetch.
  remoteNotFound,

  /// Violated parent-child relational linkage integrity (resolveParentBlockItemId).
  parentConstraintBroken,

  /// Entity attributes no longer satisfy the active filter criteria.
  filterMismatch,
}

/// The architectural rationale behind assigning or updating the current active item.
enum CurrentItemTransitionTrigger {
  /// Directly selected or targeted by the caller.
  explicitSelect,

  /// Prior current item was evicted/missing, system successfully fell back to a sibling entity.
  siblingFallback,

  /// In-memory dataset is empty or active target cleared, resetting current to null.
  resetToNull,

  /// System automatically selected a baseline item following an initial query sequence.
  initialQueryDefault,
}

/// Root sealed contract representing an atomic state transition or mutation
/// captured throughout an execution lifecycle.
@immutable
sealed class BlockOperationStep<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>> {
  final DateTime timestamp;
  final String description;

  BlockOperationStep({
    required this.description,
  }) : timestamp = DateTime.now();

  @override
  String toString() => '[$timestamp] $description';
}

/// 1. EVICTION: An item was removed or discarded from in-memory management.
final class ItemEvictionStep<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>> extends BlockOperationStep<ID, ITEM> {
  final ITEM item;
  final ItemEvictionReason reason;
  final ErrorInfo? errorInfo;

  ItemEvictionStep({
    required this.item,
    required this.reason,
    this.errorInfo,
  }) : super(
          description: 'Evicted item (${reason.name}): $item',
        );
}

/// 2. TRANSITION: Current representative item shifted or was assigned.
final class CurrentItemTransitionStep<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>> extends BlockOperationStep<ID, ITEM> {
  final ITEM? previousItem;
  final ITEM? candidateItem;
  final ITEM? finalItem;
  final CurrentItemTransitionTrigger trigger;

  CurrentItemTransitionStep({
    required this.previousItem,
    required this.candidateItem,
    required this.finalItem,
    required this.trigger,
  }) : super(
          description:
              'Current shifted from $previousItem to $finalItem via ${trigger.name}',
        );
}

/// 3. FAILURE: A localized error occurred on an item without terminating the entire queue.
final class ItemOperationFailedStep<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>> extends BlockOperationStep<ID, ITEM> {
  final ITEM? item;
  final String operation;
  final ErrorInfo errorInfo;

  ItemOperationFailedStep({
    required this.item,
    required this.operation,
    required this.errorInfo,
  }) : super(
          description:
              'Operation "$operation" failed on $item: ${errorInfo.errorMessage}',
        );
}

/// 4. CASCADE: Downstream child nodes received a cascading eviction/reset.
final class CascadedEvictionStep<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>> extends BlockOperationStep<ID, ITEM> {
  final String childBlockName;
  final BlockDataState targetState;

  CascadedEvictionStep({
    required this.childBlockName,
    required this.targetState,
  }) : super(
          description:
              'Cascaded child "$childBlockName" to state ${targetState.name}',
        );
}

/// 5. FOOTPRINT: Batch or backend side-effect impact footprint recorded for bulk operations.
final class BackendOperationFootprintStep<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>> extends BlockOperationStep<ID, ITEM> {
  final String actionName;
  final List<ID> effectedItemIds;
  final BlockViewportSyncStrategy resolvedSyncStrategy;

  BackendOperationFootprintStep({
    required this.actionName,
    required this.effectedItemIds,
    required this.resolvedSyncStrategy,
  }) : super(
          description:
              'Action "$actionName" affected ${effectedItemIds.length} items using strategy ${resolvedSyncStrategy.name}',
        );
}
