part of '../flutter_artist.dart';

class _DefaultFilterModel
    extends FilterModel<EmptyFilterInput, EmptyFilterCriteria> {
  _DefaultFilterModel({
    required String name,
    required Shelf shelf,
  }) {
    this.name = name;
    this.shelf = shelf;
  }

  @override
  FilterCriteriaStructure registerCriteriaStructure() {
    return FilterCriteriaStructure(
      simpleCriteria: [],
      multiOptCriteria: [],
    );
  }

  @override
  EmptyFilterCriteria createFilterCriteria({
    required Map<String, dynamic> dataMap,
  }) {
    return EmptyFilterCriteria();
  }

  @override
  Future<XList?> callApiLoadMultiOptCriterionData({
    required EmptyFilterInput? filterInput,
    required Object? parentMultiOptCriterionValue,
    required String multiOptCriterionName,
  }) async {
    return null;
  }

  @override
  PropValue? getMultiOptCriterionValueFromFilterInput({
    required EmptyFilterInput filterInput,
    required XOptionedData multiOptCriterionXData,
    required String multiOptCriterionName,
  }) {
    return null;
  }

  @override
  Object? getSimpleCriterionValueFromFilterInput({
    required EmptyFilterInput filterInput,
    required String criterionName,
  }) {
    return null;
  }

  @override
  PropValue? specifyDefaultMultiOptCriterionValue({
    required XOptionedData multiOptCriterionXData,
    required String multiOptCriterionName,
  }) {
    return null;
  }

  @override
  Object? specifyDefaultSimpleCriterionValue({
    required String criterionName,
  }) {
    return null;
  }
}

// -----------------------------------------------------------------------------

class StringIdFilterModel
    extends FilterModel<StringIdFilterInput, StringIdFilterCriteria> {
  String? idValue;

  StringIdFilterModel({required this.idValue});

  @override
  FilterCriteriaStructure registerCriteriaStructure() {
    return FilterCriteriaStructure(
      simpleCriteria: [],
      multiOptCriteria: [],
    );
  }

  @override
  StringIdFilterCriteria createFilterCriteria({
    required Map<String, dynamic> dataMap,
  }) {
    return StringIdFilterCriteria(idValue: idValue);
  }

  @override
  Future<XList?> callApiLoadMultiOptCriterionData({
    required StringIdFilterInput? filterInput,
    required Object? parentMultiOptCriterionValue,
    required String multiOptCriterionName,
  }) async {
    return null;
  }

  @override
  PropValue? getMultiOptCriterionValueFromFilterInput({
    required StringIdFilterInput filterInput,
    required XOptionedData multiOptCriterionXData,
    required String multiOptCriterionName,
  }) {
    return null;
  }

  @override
  Object? getSimpleCriterionValueFromFilterInput({
    required StringIdFilterInput filterInput,
    required String criterionName,
  }) {
    return null;
  }

  @override
  PropValue? specifyDefaultMultiOptCriterionValue({
    required XOptionedData multiOptCriterionXData,
    required String multiOptCriterionName,
  }) {
    return null;
  }

  @override
  Object? specifyDefaultSimpleCriterionValue({
    required String criterionName,
  }) {
    return null;
  }
}

// -----------------------------------------------------------------------------

class StringValueFilterModel
    extends FilterModel<StringValueFilterInput, StringValueFilterCriteria> {
  String? stringValue;

  StringValueFilterModel({required this.stringValue});

  @override
  FilterCriteriaStructure registerCriteriaStructure() {
    return FilterCriteriaStructure(
      simpleCriteria: [],
      multiOptCriteria: [],
    );
  }

  @override
  StringValueFilterCriteria createFilterCriteria({
    required Map<String, dynamic> dataMap,
  }) {
    return StringValueFilterCriteria(stringValue: stringValue);
  }

  @override
  Future<XList?> callApiLoadMultiOptCriterionData({
    required StringValueFilterInput? filterInput,
    required Object? parentMultiOptCriterionValue,
    required String multiOptCriterionName,
  }) async {
    return null;
  }

  @override
  PropValue? getMultiOptCriterionValueFromFilterInput({
    required StringValueFilterInput filterInput,
    required XOptionedData multiOptCriterionXData,
    required String multiOptCriterionName,
  }) {
    return null;
  }

  @override
  Object? getSimpleCriterionValueFromFilterInput({
    required StringValueFilterInput filterInput,
    required String criterionName,
  }) {
    return null;
  }

  @override
  PropValue? specifyDefaultMultiOptCriterionValue({
    required XOptionedData multiOptCriterionXData,
    required String multiOptCriterionName,
  }) {
    return null;
  }

  @override
  Object? specifyDefaultSimpleCriterionValue({
    required String criterionName,
  }) {
    return null;
  }
}

// -----------------------------------------------------------------------------

class SearchTextFilterModel
    extends FilterModel<SearchTextFilterInput, SearchTextFilterCriteria> {
  String? searchText;

  SearchTextFilterModel({required this.searchText});

  @override
  FilterCriteriaStructure registerCriteriaStructure() {
    return FilterCriteriaStructure(
      simpleCriteria: [],
      multiOptCriteria: [],
    );
  }

  @override
  SearchTextFilterCriteria createFilterCriteria({
    required Map<String, dynamic> dataMap,
  }) {
    return SearchTextFilterCriteria(searchText: searchText);
  }

  @override
  Future<XList?> callApiLoadMultiOptCriterionData({
    required SearchTextFilterInput? filterInput,
    required Object? parentMultiOptCriterionValue,
    required String multiOptCriterionName,
  }) async {
    return null;
  }

  @override
  PropValue? getMultiOptCriterionValueFromFilterInput({
    required SearchTextFilterInput filterInput,
    required XOptionedData multiOptCriterionXData,
    required String multiOptCriterionName,
  }) {
    return null;
  }

  @override
  Object? getSimpleCriterionValueFromFilterInput({
    required SearchTextFilterInput filterInput,
    required String criterionName,
  }) {
    return null;
  }

  @override
  PropValue? specifyDefaultMultiOptCriterionValue({
    required XOptionedData multiOptCriterionXData,
    required String multiOptCriterionName,
  }) {
    return null;
  }

  @override
  Object? specifyDefaultSimpleCriterionValue({
    required String criterionName,
  }) {
    return null;
  }
}

// -----------------------------------------------------------------------------

class IntIdFilterModel
    extends FilterModel<IntIdFilterInput, IntIdFilterCriteria> {
  int? idValue;

  IntIdFilterModel({required this.idValue});

  @override
  FilterCriteriaStructure registerCriteriaStructure() {
    return FilterCriteriaStructure(
      simpleCriteria: [],
      multiOptCriteria: [],
    );
  }

  @override
  IntIdFilterCriteria createFilterCriteria({
    required Map<String, dynamic> dataMap,
  }) {
    return IntIdFilterCriteria(idValue: idValue);
  }

  @override
  Future<XList?> callApiLoadMultiOptCriterionData({
    required IntIdFilterInput? filterInput,
    required Object? parentMultiOptCriterionValue,
    required String multiOptCriterionName,
  }) async {
    return null;
  }

  @override
  PropValue? getMultiOptCriterionValueFromFilterInput({
    required IntIdFilterInput filterInput,
    required XOptionedData multiOptCriterionXData,
    required String multiOptCriterionName,
  }) {
    return null;
  }

  @override
  Object? getSimpleCriterionValueFromFilterInput({
    required IntIdFilterInput filterInput,
    required String criterionName,
  }) {
    return null;
  }

  @override
  PropValue? specifyDefaultMultiOptCriterionValue({
    required XOptionedData multiOptCriterionXData,
    required String multiOptCriterionName,
  }) {
    return null;
  }

  @override
  Object? specifyDefaultSimpleCriterionValue({
    required String criterionName,
  }) {
    return null;
  }
}

// -----------------------------------------------------------------------------
