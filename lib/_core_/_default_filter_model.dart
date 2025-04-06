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
      optCriteria: [],
    );
  }

  @override
  EmptyFilterCriteria createFilterCriteria({
    required Map<String, dynamic> dataMap,
  }) {
    return EmptyFilterCriteria();
  }

  @override
  Future<XList?> callApiLoadOptCriterionData({
    required EmptyFilterInput? filterInput,
    required Object? parentOptCriterionValue,
    required String criterionName,
  }) async {
    return null;
  }

  @override
  PropValue? getOptCriterionValueFromFilterInput({
    required EmptyFilterInput filterInput,
    required XOptionedData optCriterionData,
    required String criterionName,
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
  PropValue? specifyDefaultOptCriterionValue({
    required XOptionedData optCriterionData,
    required String criterionName,
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
      optCriteria: [],
    );
  }

  @override
  StringIdFilterCriteria createFilterCriteria({
    required Map<String, dynamic> dataMap,
  }) {
    return StringIdFilterCriteria(idValue: idValue);
  }

  @override
  Future<XList?> callApiLoadOptCriterionData({
    required StringIdFilterInput? filterInput,
    required Object? parentOptCriterionValue,
    required String criterionName,
  }) async {
    return null;
  }

  @override
  PropValue? getOptCriterionValueFromFilterInput({
    required StringIdFilterInput filterInput,
    required XOptionedData optCriterionData,
    required String criterionName,
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
  PropValue? specifyDefaultOptCriterionValue({
    required XOptionedData optCriterionData,
    required String criterionName,
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
      optCriteria: [],
    );
  }

  @override
  StringValueFilterCriteria createFilterCriteria({
    required Map<String, dynamic> dataMap,
  }) {
    return StringValueFilterCriteria(stringValue: stringValue);
  }

  @override
  Future<XList?> callApiLoadOptCriterionData({
    required StringValueFilterInput? filterInput,
    required Object? parentOptCriterionValue,
    required String criterionName,
  }) async {
    return null;
  }

  @override
  PropValue? getOptCriterionValueFromFilterInput({
    required StringValueFilterInput filterInput,
    required XOptionedData optCriterionData,
    required String criterionName,
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
  PropValue? specifyDefaultOptCriterionValue({
    required XOptionedData optCriterionData,
    required String criterionName,
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
      optCriteria: [],
    );
  }

  @override
  SearchTextFilterCriteria createFilterCriteria({
    required Map<String, dynamic> dataMap,
  }) {
    return SearchTextFilterCriteria(searchText: searchText);
  }

  @override
  Future<XList?> callApiLoadOptCriterionData({
    required SearchTextFilterInput? filterInput,
    required Object? parentOptCriterionValue,
    required String criterionName,
  }) async {
    return null;
  }

  @override
  PropValue? getOptCriterionValueFromFilterInput({
    required SearchTextFilterInput filterInput,
    required XOptionedData optCriterionData,
    required String criterionName,
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
  PropValue? specifyDefaultOptCriterionValue({
    required XOptionedData optCriterionData,
    required String criterionName,
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
      optCriteria: [],
    );
  }

  @override
  IntIdFilterCriteria createFilterCriteria({
    required Map<String, dynamic> dataMap,
  }) {
    return IntIdFilterCriteria(idValue: idValue);
  }

  @override
  Future<XList?> callApiLoadOptCriterionData({
    required IntIdFilterInput? filterInput,
    required Object? parentOptCriterionValue,
    required String criterionName,
  }) async {
    return null;
  }

  @override
  PropValue? getOptCriterionValueFromFilterInput({
    required IntIdFilterInput filterInput,
    required XOptionedData optCriterionData,
    required String criterionName,
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
  PropValue? specifyDefaultOptCriterionValue({
    required XOptionedData optCriterionData,
    required String criterionName,
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
