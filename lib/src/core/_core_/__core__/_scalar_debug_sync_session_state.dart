part of '../core.dart';

abstract interface class DebugScalarSyncSessionState<ID extends Comparable> {
  Scalar<
      Comparable, //
      Identifiable<Comparable>,
      FilterInput,
      FilterCriteria> get scalar;

  Comparable? get parentScalarValueId;

  FilterCriteria? get filterCriteria;

  List<ScalarReceivedEventInfo<ID>> get receivedEventInfos;
}
