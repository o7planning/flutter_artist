part of '../core.dart';

/// Contract representing diagnostic inspecting data for an active item sync session.
abstract interface class DebugBlockItemSyncSessionState<ID extends Comparable> {
  ID get targetItemId;
  List<BlockReceivedEventInfo<ID>> get receivedEventInfos;
  bool get isStale;
}
