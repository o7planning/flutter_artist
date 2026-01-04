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
  FilterModelStructure registerFilterModelStructure() {
    return FilterModelStructure(
      simpleCriterionDefs: [],
      multiOptCriterionDefs: [],
      filterCriteriaGroupDef: FilterCriteriaGroupDef(
        groupName: 'rootCriteriaGroup',
        conjunction: Conjunction.and,
        members: [],
      ),
    );
  }

  @override
  Future<ListXData?> callApiLoadMultiOptCriterionXData({
    required String criteriaGroupName,
    required String multiOptCriterionName,
    required SelectionType selectionType,
    required Object? parentMultiOptCriterionValue,
    required EmptyFilterInput? filterInput,
  }) async {
    return null;
  }

  @override
  OptValueWrap? getUpdatedValueForMultiOptCriterion({
    required String criteriaGroupName,
    required String multiOptCriterionName,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required EmptyFilterInput filterInput,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, SimpleValueWrap?>? getUpdatedValuesForSimpleCriteria({
    required String criteriaGroupName,
    required EmptyFilterInput filterInput,
  }) {
    return null;
  }

  @override
  OptValueWrap? specifyDefaultValueForMultiOptCriterion({
    required String criteriaGroupName,
    required String multiOptCriterionName,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, dynamic>? specifyDefaultValuesForSimpleCriteria({
    required String criteriaGroupName,
  }) {
    return null;
  }

  @override
  EmptyFilterCriteria toFilterCriteriaObject({
    required Map<String, dynamic> criteriaMap,
    required FilterCriteriaGroupModel filterCriteriaGroup,
    required List<FilterCriterion> filterCriteria,
  }) {
    return EmptyFilterCriteria();
  }
}
