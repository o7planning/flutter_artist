part of '../core.dart';

class _ScalarSyncSessionState<ID extends Comparable> extends Equatable
    implements DebugScalarSyncSessionState<ID> {
  @override
  final Scalar<
      Comparable, //
      Identifiable<Comparable>,
      FilterInput,
      FilterCriteria> scalar;

  @override
  final Comparable? parentScalarValueId;

  @override
  final FilterCriteria? filterCriteria;

  final List<ScalarReceivedEventInfo<ID>> _receivedEventInfos = [];

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

  @override
  List<Object?> get props => [parentScalarValueId, filterCriteria];

  @override
  String toString() {
    return "parentScalarValueId: $parentScalarValueId, filterCriteria: ${filterCriteria == null ? 'null' : 'OK'}";
  }
}
