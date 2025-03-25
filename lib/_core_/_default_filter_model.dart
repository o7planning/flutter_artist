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
  PropsStructure? registerPropsStructure() {
    return null;
  }

  @override
  EmptyFilterCriteria createFilterCriteria({
    required Map<String, dynamic> dataMap,
  }) {
    return EmptyFilterCriteria();
  }

  @override
  Future<XList?> callApiLoadOptPropData({
    required EmptyFilterInput? filterInput,
    required Object? parentOptPropValue,
    required String propName,
  }) async {
    return null;
  }

  @override
  PropValue? filterInputToOptPropValue({
    required EmptyFilterInput filterInput,
    required XOptionedData optPropData,
    required String propName,
  }) {
    return null;
  }

  @override
  Object? filterInputToCommonPropValue({
    required EmptyFilterInput filterInput,
    required String propName,
  }) {
    return null;
  }

  @override
  PropValue? specifyDefaultOptPropValue({
    required XOptionedData optPropData,
    required String propName,
  }) {
    return null;
  }

  @override
  Object? specifyDefaultCommonPropValue({
    required String propName,
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
  PropsStructure? registerPropsStructure() {
    return null;
  }

  @override
  StringIdFilterCriteria createFilterCriteria({
    required Map<String, dynamic> dataMap,
  }) {
    return StringIdFilterCriteria(idValue: idValue);
  }

  @override
  Future<XList?> callApiLoadOptPropData({
    required StringIdFilterInput? filterInput,
    required Object? parentOptPropValue,
    required String propName,
  }) async {
    return null;
  }

  @override
  PropValue? filterInputToOptPropValue({
    required StringIdFilterInput filterInput,
    required XOptionedData optPropData,
    required String propName,
  }) {
    return null;
  }

  @override
  Object? filterInputToCommonPropValue({
    required StringIdFilterInput filterInput,
    required String propName,
  }) {
    return null;
  }

  @override
  PropValue? specifyDefaultOptPropValue({
    required XOptionedData optPropData,
    required String propName,
  }) {
    return null;
  }

  @override
  Object? specifyDefaultCommonPropValue({
    required String propName,
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
  PropsStructure? registerPropsStructure() {
    return null;
  }

  @override
  StringValueFilterCriteria createFilterCriteria({
    required Map<String, dynamic> dataMap,
  }) {
    return StringValueFilterCriteria(stringValue: stringValue);
  }

  @override
  Future<XList?> callApiLoadOptPropData({
    required StringValueFilterInput? filterInput,
    required Object? parentOptPropValue,
    required String propName,
  }) async {
    return null;
  }

  @override
  PropValue? filterInputToOptPropValue({
    required StringValueFilterInput filterInput,
    required XOptionedData optPropData,
    required String propName,
  }) {
    return null;
  }

  @override
  Object? filterInputToCommonPropValue({
    required StringValueFilterInput filterInput,
    required String propName,
  }) {
    return null;
  }

  @override
  PropValue? specifyDefaultOptPropValue({
    required XOptionedData optPropData,
    required String propName,
  }) {
    return null;
  }

  @override
  Object? specifyDefaultCommonPropValue({
    required String propName,
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
  PropsStructure? registerPropsStructure() {
    return null;
  }

  @override
  SearchTextFilterCriteria createFilterCriteria({
    required Map<String, dynamic> dataMap,
  }) {
    return SearchTextFilterCriteria(searchText: searchText);
  }

  @override
  Future<XList?> callApiLoadOptPropData({
    required SearchTextFilterInput? filterInput,
    required Object? parentOptPropValue,
    required String propName,
  }) async {
    return null;
  }

  @override
  PropValue? filterInputToOptPropValue({
    required SearchTextFilterInput filterInput,
    required XOptionedData optPropData,
    required String propName,
  }) {
    return null;
  }

  @override
  Object? filterInputToCommonPropValue({
    required SearchTextFilterInput filterInput,
    required String propName,
  }) {
    return null;
  }

  @override
  PropValue? specifyDefaultOptPropValue({
    required XOptionedData optPropData,
    required String propName,
  }) {
    return null;
  }

  @override
  Object? specifyDefaultCommonPropValue({
    required String propName,
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
  PropsStructure? registerPropsStructure() {
    return null;
  }

  @override
  IntIdFilterCriteria createFilterCriteria({
    required Map<String, dynamic> dataMap,
  }) {
    return IntIdFilterCriteria(idValue: idValue);
  }

  @override
  Future<XList?> callApiLoadOptPropData({
    required IntIdFilterInput? filterInput,
    required Object? parentOptPropValue,
    required String propName,
  }) async {
    return null;
  }

  @override
  PropValue? filterInputToOptPropValue({
    required IntIdFilterInput filterInput,
    required XOptionedData optPropData,
    required String propName,
  }) {
    return null;
  }

  @override
  Object? filterInputToCommonPropValue({
    required IntIdFilterInput filterInput,
    required String propName,
  }) {
    return null;
  }

  @override
  PropValue? specifyDefaultOptPropValue({
    required XOptionedData optPropData,
    required String propName,
  }) {
    return null;
  }

  @override
  Object? specifyDefaultCommonPropValue({
    required String propName,
  }) {
    return null;
  }
}

// -----------------------------------------------------------------------------
