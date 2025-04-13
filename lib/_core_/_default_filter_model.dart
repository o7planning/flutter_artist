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
    required String multiOptCriterionName,
    required Object? parentMultiOptCriterionValue,
    required EmptyFilterInput? filterInput,
  }) async {
    return null;
  }

  @override
  ValueWrap? getMultiOptCriterionValueFromFilterInput({
    required String multiOptCriterionName,
    required XOptionedData multiOptCriterionXData,
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
    required XOptionedData multiOptCriterionXData,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Future<Map<String, dynamic>?> specifyDefaultSimpleCriterionValues() async {
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
    required String multiOptCriterionName,
    required Object? parentMultiOptCriterionValue,
    required StringIdFilterInput? filterInput,
  }) async {
    return null;
  }

  @override
  ValueWrap? getMultiOptCriterionValueFromFilterInput({
    required String multiOptCriterionName,
    required XOptionedData multiOptCriterionXData,
    required StringIdFilterInput filterInput,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Future<Map<String, dynamic>?> getSimpleCriterionValuesFromFilterInput({
    required StringIdFilterInput filterInput,
  }) async {
    return null;
  }

  @override
  ValueWrap? specifyDefaultMultiOptCriterionValue({
    required String multiOptCriterionName,
    required XOptionedData multiOptCriterionXData,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Future<Map<String, dynamic>?> specifyDefaultSimpleCriterionValues() async {
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
    required String multiOptCriterionName,
    required StringValueFilterInput? filterInput,
    required Object? parentMultiOptCriterionValue,
  }) async {
    return null;
  }

  @override
  ValueWrap? getMultiOptCriterionValueFromFilterInput({
    required String multiOptCriterionName,
    required StringValueFilterInput filterInput,
    required Object? parentMultiOptCriterionValue,
    required XOptionedData multiOptCriterionXData,
  }) {
    return null;
  }

  @override
  Future<Map<String, dynamic>?> getSimpleCriterionValuesFromFilterInput({
    required StringValueFilterInput filterInput,
  }) async {
    return null;
  }

  @override
  ValueWrap? specifyDefaultMultiOptCriterionValue({
    required String multiOptCriterionName,
    required XOptionedData multiOptCriterionXData,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Future<Map<String, dynamic>?> specifyDefaultSimpleCriterionValues() async {
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
    required String multiOptCriterionName,
    required SearchTextFilterInput? filterInput,
    required Object? parentMultiOptCriterionValue,
  }) async {
    return null;
  }

  @override
  ValueWrap? getMultiOptCriterionValueFromFilterInput({
    required String multiOptCriterionName,
    required XOptionedData multiOptCriterionXData,
    required SearchTextFilterInput filterInput,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Future<Map<String, dynamic>?> getSimpleCriterionValuesFromFilterInput({
    required SearchTextFilterInput filterInput,
  }) async {
    return null;
  }

  @override
  ValueWrap? specifyDefaultMultiOptCriterionValue({
    required String multiOptCriterionName,
    required XOptionedData multiOptCriterionXData,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Future<Map<String, dynamic>?> specifyDefaultSimpleCriterionValues() async {
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
    required String multiOptCriterionName,
    required Object? parentMultiOptCriterionValue,
    required IntIdFilterInput? filterInput,
  }) async {
    return null;
  }

  @override
  ValueWrap? getMultiOptCriterionValueFromFilterInput({
    required String multiOptCriterionName,
    required XOptionedData multiOptCriterionXData,
    required IntIdFilterInput filterInput,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Future<Map<String, dynamic>?> getSimpleCriterionValuesFromFilterInput({
    required IntIdFilterInput filterInput,
  }) async {
    return null;
  }

  @override
  ValueWrap? specifyDefaultMultiOptCriterionValue({
    required String multiOptCriterionName,
    required XOptionedData multiOptCriterionXData,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Future<Map<String, dynamic>?> specifyDefaultSimpleCriterionValues() async {
    return null;
  }
}

// -----------------------------------------------------------------------------
