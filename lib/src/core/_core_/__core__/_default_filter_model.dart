part of '../core.dart';

class _DefaultFilterModel
    extends FilterModel<EmptyFilterInput, EmptyFilterCriteria> {
  _DefaultFilterModel({
    required String name,
    required Shelf shelf,
  }) {
    this.name = name;
    this.shelf = shelf;
    _isDefaultFilterModel = true;
  }

  @override
  FilterCriteriaStructure registerCriteriaStructure() {
    return FilterCriteriaStructure(
      simpleCriteria: [],
      multiOptCriteria: [],
    );
  }

  @override
  EmptyFilterCriteria toFilterCriteriaObject({
    required Map<String, dynamic> dataMap,
  }) {
    return EmptyFilterCriteria();
  }

  @override
  Future<ListXData?> callApiLoadMultiOptCriterionXData({
    required String multiOptCriterionName,
    required SelectionType selectionType,
    required Object? parentMultiOptCriterionValue,
    required EmptyFilterInput? filterInput,
  }) async {
    return null;
  }

  @override
  ValueWrap? getMultiOptCriterionValueFromFilterInput({
    required String multiOptCriterionName,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required EmptyFilterInput filterInput,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Future<Map<String, dynamic>?> getSimpleCriterionValuesFromFilterInput({
    required EmptyFilterInput filterInput,
  }) async {
    return null;
  }

  @override
  ValueWrap? specifyDefaultMultiOptCriterionValue({
    required String multiOptCriterionName,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Future<Map<String, dynamic>?> specifyDefaultSimpleCriterionValues() async {
    return null;
  }
}
