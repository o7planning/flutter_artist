part of '../core.dart';

class _BlockDebugInfo<ID extends Comparable> {
  final Block<ID,
      Identifiable<ID>,
      Identifiable<ID>,
      FilterInput,
      FilterCriteria,
      FormInput,
      AdditionalFormRelatedData> _block;

  int _lazyLoadCount = 0;

  int get lazyLoadCount => _lazyLoadCount;

  int __performLoadItemDetailByIdCount = 0;

  int get performLoadItemDetailByIdCount => __performLoadItemDetailByIdCount;

  int _deletionErrorCount = 0;

  int get deletionErrorCount => _deletionErrorCount;

  int __performQueryCount = 0;

  int get performQueryCount => __performQueryCount;

  int __performQueryByItemIdsCount = 0;

  int get performQueryByItemIdsCount => __performQueryByItemIdsCount;

  DebugBlockSyncSessionState? get syncSessionState =>
      _block._blockSyncSessionState;

  int _filterCriteriaChangeCount = 0;

  int get filterCriteriaChangeCount => _filterCriteriaChangeCount;

  int _currentItemChangeCount = 0;

  int get currentItemChangeCount => _currentItemChangeCount;

  ListUpdateStrategy? get lastForceListUpdateStrategy =>
      _block.__blockData._lastForceListUpdateStrategy;

  String get classDefinition {
    return "${getClassName(this)}$classParametersDefinition";
  }

  String get classParametersDefinition {
    return "<${_block.getItemIdType()}, ${_block.getItemType()}, ${_block
        .getItemDetailType()}, "
        "${_block.getFilterInputType()}, ${_block.getFilterCriteriaType()}, "
        "${_block.getFormInputType()}, ${_block.getFormRelatedDataType()}>";
  }

  Set<ID> _lastEffectiveItemIds = {};

  Set<ID> get lastEffectiveItemIds => _lastEffectiveItemIds;

  Set<ID> _lastPerformQueryItemIds = {};

  Set<ID> get lastPerformQueryItemIds => _lastPerformQueryItemIds;

  BlockViewportSyncStrategy? _lastViewportSyncStrategy;

  BlockViewportSyncStrategy? get lastViewportSyncStrategy =>
      _lastViewportSyncStrategy;

  int _querySessionCount = 0;

  int get querySessionCount => _querySessionCount;

  int _viewportSyncStrategyChangeCount = 0;

  int get viewportSyncStrategyChangeCount => _viewportSyncStrategyChangeCount;

  _BlockDebugInfo({
    required Block<
        ID, //
        Identifiable<ID>,
        Identifiable<ID>,
        FilterInput,
        FilterCriteria,
        FormInput,
        AdditionalFormRelatedData>
    block,
  }) : _block = block;
}
