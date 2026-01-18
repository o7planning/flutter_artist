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
  FilterModelStructure registerCriteriaStructure() {
    return FilterModelStructure(
      simpleCriteria: [],
      multiOptCriteria: [],
    );
  }

  @override
  Future<ListXData?> callApiLoadMultiOptCriterionXData({
    required String multiOptCriterionNameX,
    required SelectionType selectionType,
    required Object? parentMultiOptCriterionValue,
    required EmptyFilterInput? filterInput,
  }) async {
    return null;
  }

  @override
  OptValueWrap? getUpdatedValueForMultiOptCriterion({
    required String multiOptCriterionNameX,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required EmptyFilterInput filterInput,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, SimpleValueWrap?>? getUpdatedValuesForSimpleCriteria({
    required EmptyFilterInput filterInput,
  }) {
    return null;
  }

  @override
  OptValueWrap? specifyDefaultValueForMultiOptCriterion({
    required String multiOptCriterionNameX,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, dynamic>? specifyDefaultValuesForSimpleCriteria() {
    return null;
  }

  @override
  EmptyFilterCriteria toFilterCriteriaObject({
    required Map<String, dynamic> criteriaMap,
  }) {
    return EmptyFilterCriteria();
  }
}
