part of '../core.dart';

class _ScalarSyncSessionState extends Equatable {
  final Scalar<
      Object, //
      FilterInput,
      FilterCriteria> scalar;

  final String? parentScalarValueId;
  final FilterCriteria? filterCriteria;

  List<ScalarReceivedEventInfo> _receivedEventInfos = [];

  @override
  List<ScalarReceivedEventInfo> get receivedEventInfos =>
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
    final eventInfo = ScalarReceivedEventInfo(
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
