part of '../core.dart';

class _ScalarSyncSessionState<ID extends Comparable> extends Equatable
    implements DebugScalarSyncSessionState<ID> {
  @override
  final Scalar<
      Comparable,
      Identifiable<Comparable>, //
      FilterInput,
      FilterCriteria> scalar;

  @override
  final Comparable? parentScalarValueId;

  @override
  final FilterCriteria? filterCriteria;

  List<ScalarReceivedEventInfo<ID>> _receivedEventInfos = [];

  @override
  List<ScalarReceivedEventInfo<ID>> get receivedEventInfos =>
      List.unmodifiable(_receivedEventInfos);

  _ScalarSyncSessionState({
    required this.scalar,
    required this.parentScalarValueId,
    required this.filterCriteria,
  });

  void addReceivedEventInfo({
    required EventSourceType eventSourceType,
    required List<Type> dataTypes,
  }) {
    final eventInfo = ScalarReceivedEventInfo<ID>(
      eventSourceType: eventSourceType,
      dataTypes: dataTypes,
    );
    _receivedEventInfos.add(eventInfo);
  }

  /// Evaluates and recalculates the next [ScalarDataState] when new events invalidate this scalar.
  ScalarDataState calculateNextDataState(ScalarDataState currentDataState) {
    // 1. Uninitialized/cold states remain unaffected by external incoming events
    if (currentDataState.isNone || currentDataState.isPending) {
      return currentDataState;
    }

    // 2. If already STALE, preserve the current stale state
    if (currentDataState.isStale) {
      return currentDataState;
    }

    // 3. If currently FRESH, transition to STALE due to received event invalidation
    if (currentDataState.isFresh) {
      final isFromInternalShelf = _receivedEventInfos.any(
            (info) => info.eventSourceType == EventSourceType.internal,
      );

      return ScalarDataStateLoadedStale(
        reason: ScalarLoadedStateStaleReasonEvent(),
      );
    }

    return currentDataState;
  }

  @override
  List<Object?> get props => [parentScalarValueId, filterCriteria];

  @override
  String toString() {
    return "parentScalarValueId: $parentScalarValueId, filterCriteria: ${filterCriteria ==
        null ? 'null' : 'OK'}";
  }
}
