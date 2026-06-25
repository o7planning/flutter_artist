part of '../core.dart';

class _BlockDebugInfo<ID extends Object> {
  final Block<ID, Identifiable<ID>, Identifiable<ID>, FilterInput,
      FilterCriteria, FormInput, AdditionalFormRelatedData> _block;

  int __performQueryCount = 0;

  int __performQueryByItemIdsCount = 0;

  int _lazyLoadCount = 0;

  int __performLoadItemDetailByIdCount = 0;

  int get lazyLoadCount => _lazyLoadCount;

  int _deletionErrorCount = 0;

  int get deletionErrorCount => _deletionErrorCount;

  int get performLoadItemDetailByIdCount => __performLoadItemDetailByIdCount;

  int get performQueryCount => __performQueryCount;

  int get performQueryByItemIdsCount => __performQueryByItemIdsCount;

  int get currentItemChangeCount => _block.__blockData._currentItemChangeCount;

  late final requeryCondition = _DebugBlockRequeryCondition<ID>();

  ListUpdateStrategy? get lastForceListUpdateStrategy =>
      _block.__blockData._lastForceListUpdateStrategy;

  String get classDefinition {
    return "${getClassName(this)}$classParametersDefinition";
  }

  String get classParametersDefinition {
    return "<${_block.getItemIdType()}, ${_block.getItemType()}, ${_block.getItemDetailType()}, "
        "${_block.getFilterInputType()}, ${_block.getFilterCriteriaType()}, "
        "${_block.getFormInputType()}, ${_block.getFormRelatedDataType()}>";
  }

  int get filterCriteriaChangeCount =>
      _block.__blockData._filterCriteriaChangeCount;

  _BlockDebugInfo(
      {required Block<ID, Identifiable<ID>, Identifiable<ID>, FilterInput,
              FilterCriteria, FormInput, AdditionalFormRelatedData>
          block})
      : _block = block;
}
