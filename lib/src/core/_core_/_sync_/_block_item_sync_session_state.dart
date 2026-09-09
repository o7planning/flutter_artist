part of '../core.dart';

/// Runtime session state managing deferred refreshes, event accumulation,
/// and staleness tracking targeted strictly at the block's active [currentItem].
class _BlockItemSyncSessionState<ID extends Comparable> extends Equatable
    implements DebugBlockItemSyncSessionState<ID> {
  /// Reference to the owner block.
  final Block<ID, Identifiable<ID>, Identifiable<ID>, FilterInput,
      FilterCriteria, FormInput, AdditionalFormRelatedData> block;

  /// The specific item identity bound to this sync session.
  final ID _targetItemId;

  @override
  ID get targetItemId => _targetItemId;

  final List<BlockReceivedEventInfo<ID>> _receivedEventInfos = [];

  @override
  List<BlockReceivedEventInfo<ID>> get receivedEventInfos =>
      List.unmodifiable(_receivedEventInfos);

  bool _isStale = false;

  @override
  bool get isStale => _isStale;

  _BlockItemSyncSessionState({
    required this.block,
    required ID targetItemId,
  }) : _targetItemId = targetItemId {
    _isStale = true;
  }

  /// Appends incoming event metadata that targeted this specific item.
  void addReceivedEventInfo({
    required EventSourceType eventSourceType,
    required List<Type> mainDataTypes,
    required List<Type> extraDataTypes,
    required List<ID> effectedItemIds,
  }) {
    final eventInfo = BlockReceivedEventInfo<ID>(
      eventSourceType: eventSourceType,
      requiresMaxSyncStrategy: false,
      syncStrategyOnFullQueryMode: null,
      syncStrategyOnPageableQueryMode: null,
      dataTypes: mainDataTypes,
      effectedItemIds: effectedItemIds,
    );
    _receivedEventInfos.add(eventInfo);
    _isStale = true;
  }

  /// Verifies if this session is still valid for the active item.
  bool isValidFor(ID? activeItemId) {
    if (activeItemId == null) return false;
    return _targetItemId == activeItemId;
  }

  @override
  List<Object?> get props =>
      [_targetItemId, _isStale, _receivedEventInfos.length];

  @override
  String toString() =>
      'ItemSyncSession(targetItemId: $_targetItemId, isStale: $_isStale, events: ${_receivedEventInfos.length})';
}
