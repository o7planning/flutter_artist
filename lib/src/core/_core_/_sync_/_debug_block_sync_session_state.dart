part of '../core.dart';

abstract interface class DebugBlockSyncSessionState<ID extends Comparable> {
  Block<
      ID, //
      Identifiable<ID>,
      Identifiable<ID>,
      FilterPatch,
      FilterCriteria,
      CreationPreset,
      FormPatch> get block;

  Comparable? get parentBlockItemId;

  FilterCriteria? get filterCriteria;

  List<BlockReceivedEventInfo<ID>> get receivedEventInfos;

  Set<ID> getEffectedItemIds();

  Set<ID> getPerformQueryItemIds(List<ID> blockItemIds);
}
