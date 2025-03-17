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
  MasterDataStructure? registerMasterDataStructure() {
    return null;
  }

  @override
  EmptyFilterCriteria createFilterCriteria({
    required Map<String, dynamic> dataMap,
  }) {
    return EmptyFilterCriteria();
  }

  @override
  Map<String, dynamic> filterInputToCriteriaDataMap({
    required EmptyFilterInput filterInput,
  }) {
    return {};
  }

  @override
  Map<String, dynamic> initialCriteriaDataMap() {
    return {};
  }

  @override
  Future<XList?> prepareMasterPropDataForListType({
    required EmptyFilterInput? filterInput,
    required Object? parentMasterPropValue,
    required String propName,
  }) async {
    return null;
  }

  @override
  Future<Object?> prepareMasterPropDataForCustomType({
    required EmptyFilterInput? filterInput,
    required Object? parentMasterPropValue,
    required String propName,
  }) async {
    return null;
  }

  @override
  MasterPropValueWrap? filterInputToMasterPropValue({
    required EmptyFilterInput filterInput,
    required XList materPropData,
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
  MasterDataStructure? registerMasterDataStructure() {
    return null;
  }

  @override
  StringIdFilterCriteria createFilterCriteria({
    required Map<String, dynamic> dataMap,
  }) {
    return StringIdFilterCriteria(idValue: idValue);
  }

  @override
  Map<String, dynamic> filterInputToCriteriaDataMap({
    required StringIdFilterInput filterInput,
  }) {
    return {"idValue": idValue};
  }

  @override
  Map<String, dynamic> initialCriteriaDataMap() {
    return {};
  }

  @override
  Future<XList?> prepareMasterPropDataForListType({
    required StringIdFilterInput? filterInput,
    required Object? parentMasterPropValue,
    required String propName,
  }) async {
    return null;
  }

  @override
  Future<Object?> prepareMasterPropDataForCustomType({
    required StringIdFilterInput? filterInput,
    required Object? parentMasterPropValue,
    required String propName,
  }) async {
    return null;
  }

  @override
  MasterPropValueWrap? filterInputToMasterPropValue({
    required StringIdFilterInput filterInput,
    required XList materPropData,
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
  MasterDataStructure? registerMasterDataStructure() {
    return null;
  }

  @override
  StringValueFilterCriteria createFilterCriteria({
    required Map<String, dynamic> dataMap,
  }) {
    return StringValueFilterCriteria(stringValue: stringValue);
  }

  @override
  Map<String, dynamic> filterInputToCriteriaDataMap({
    required StringValueFilterInput filterInput,
  }) {
    return {"stringValue": stringValue};
  }

  @override
  Map<String, dynamic> initialCriteriaDataMap() {
    return {};
  }

  @override
  Future<XList?> prepareMasterPropDataForListType({
    required StringValueFilterInput? filterInput,
    required Object? parentMasterPropValue,
    required String propName,
  }) async {
    return null;
  }

  @override
  Future<Object?> prepareMasterPropDataForCustomType({
    required StringValueFilterInput? filterInput,
    required Object? parentMasterPropValue,
    required String propName,
  }) async {
    return null;
  }

  @override
  MasterPropValueWrap? filterInputToMasterPropValue({
    required StringValueFilterInput filterInput,
    required XList materPropData,
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
  MasterDataStructure? registerMasterDataStructure() {
    return null;
  }

  @override
  SearchTextFilterCriteria createFilterCriteria({
    required Map<String, dynamic> dataMap,
  }) {
    return SearchTextFilterCriteria(searchText: searchText);
  }

  @override
  Map<String, dynamic> filterInputToCriteriaDataMap({
    required SearchTextFilterInput filterInput,
  }) {
    return {"searchText": searchText};
  }

  @override
  Map<String, dynamic> initialCriteriaDataMap() {
    return {};
  }

  @override
  Future<XList?> prepareMasterPropDataForListType({
    required SearchTextFilterInput? filterInput,
    required Object? parentMasterPropValue,
    required String propName,
  }) async {
    return null;
  }

  @override
  Future<Object?> prepareMasterPropDataForCustomType({
    required SearchTextFilterInput? filterInput,
    required Object? parentMasterPropValue,
    required String propName,
  }) async {
    return null;
  }

  @override
  MasterPropValueWrap? filterInputToMasterPropValue({
    required SearchTextFilterInput filterInput,
    required XList materPropData,
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
  MasterDataStructure? registerMasterDataStructure() {
    return null;
  }

  @override
  IntIdFilterCriteria createFilterCriteria({
    required Map<String, dynamic> dataMap,
  }) {
    return IntIdFilterCriteria(idValue: idValue);
  }

  @override
  Map<String, dynamic> filterInputToCriteriaDataMap({
    required IntIdFilterInput filterInput,
  }) {
    return {"idValue": idValue};
  }

  @override
  Map<String, dynamic> initialCriteriaDataMap() {
    return {};
  }

  @override
  Future<XList?> prepareMasterPropDataForListType({
    required IntIdFilterInput? filterInput,
    required Object? parentMasterPropValue,
    required String propName,
  }) async {
    return null;
  }

  @override
  Future<Object?> prepareMasterPropDataForCustomType({
    required IntIdFilterInput? filterInput,
    required Object? parentMasterPropValue,
    required String propName,
  }) async {
    return null;
  }

  @override
  MasterPropValueWrap? filterInputToMasterPropValue({
    required IntIdFilterInput filterInput,
    required XList materPropData,
    required String propName,
  }) {
    return null;
  }
}

// -----------------------------------------------------------------------------
