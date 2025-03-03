part of '../flutter_artist.dart';

class _DefaultDataFilter
    extends DataFilter<EmptyFilterInput, EmptyFilterCriteria> {
  _DefaultDataFilter({
    required String name,
    required Shelf shelf,
  }) {
    this.name = name;
    this.shelf = shelf;
  }

  @override
  @Deprecated("Xoa di, khong su dung nua")
  Future<void> prepareData({
    EmptyFilterInput? filterInput,
  }) async {
    // Do nothing
  }

  @override
  List<Restorable> get restorableCriteria => [];

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
  Future<void> prepareMasterFilterData({
    required EmptyFilterInput? filterInput,
  }) async {
    // Do nothing.
  }

  @override
  Map<String, dynamic> initDefaultFilterCriteria() {
    return {};
  }
}

// -----------------------------------------------------------------------------

class StringIdDataFilter
    extends DataFilter<StringIdFilterInput, StringIdFilterCriteria> {
  String? idValue;

  StringIdDataFilter({required this.idValue});

  @override
  StringIdFilterCriteria createFilterCriteria({
    required Map<String, dynamic> dataMap,
  }) {
    return StringIdFilterCriteria(idValue: idValue);
  }

  @override
  List<Restorable> get restorableCriteria => [];

  @override
  Map<String, dynamic> filterInputToCriteriaDataMap({
    required StringIdFilterInput filterInput,
  }) {
    return {"idValue": idValue};
  }

  @override
  Future<void> prepareMasterFilterData({
    required StringIdFilterInput? filterInput,
  }) async {
    if (filterInput != null) {
      idValue = filterInput.idValue;
    }
  }

  @override
  Map<String, dynamic> initDefaultFilterCriteria() {
    return {};
  }
}

// -----------------------------------------------------------------------------

class StringValueDataFilter
    extends DataFilter<StringValueFilterInput, StringValueFilterCriteria> {
  String? stringValue;

  StringValueDataFilter({required this.stringValue});

  @override
  StringValueFilterCriteria createFilterCriteria({
    required Map<String, dynamic> dataMap,
  }) {
    return StringValueFilterCriteria(stringValue: stringValue);
  }

  @override
  List<Restorable> get restorableCriteria => [];

  @override
  Map<String, dynamic> filterInputToCriteriaDataMap({
    required StringValueFilterInput filterInput,
  }) {
    return {"stringValue": stringValue};
  }

  @override
  Future<void> prepareMasterFilterData({
    required StringValueFilterInput? filterInput,
  }) async {
    if (filterInput != null) {
      stringValue = filterInput.stringValue;
    }
  }

  @override
  Map<String, dynamic> initDefaultFilterCriteria() {
    return {};
  }
}

// -----------------------------------------------------------------------------

class SearchTextDataFilter
    extends DataFilter<SearchTextFilterInput, SearchTextFilterCriteria> {
  String? searchText;

  SearchTextDataFilter({required this.searchText});

  @override
  SearchTextFilterCriteria createFilterCriteria({
    required Map<String, dynamic> dataMap,
  }) {
    return SearchTextFilterCriteria(searchText: searchText);
  }

  @override
  List<Restorable> get restorableCriteria => [];

  @override
  Map<String, dynamic> filterInputToCriteriaDataMap({
    required SearchTextFilterInput filterInput,
  }) {
    return {"searchText": searchText};
  }

  @override
  Future<void> prepareMasterFilterData({
    required SearchTextFilterInput? filterInput,
  }) async {
    if (filterInput != null) {
      searchText = filterInput.searchText;
    }
  }

  @override
  Map<String, dynamic> initDefaultFilterCriteria() {
    return {};
  }
}

// -----------------------------------------------------------------------------

class IntIdDataFilter
    extends DataFilter<IntIdFilterInput, IntIdFilterCriteria> {
  int? idValue;

  IntIdDataFilter({required this.idValue});

  @override
  IntIdFilterCriteria createFilterCriteria({
    required Map<String, dynamic> dataMap,
  }) {
    return IntIdFilterCriteria(idValue: idValue);
  }

  @override
  List<Restorable> get restorableCriteria => [];

  @override
  Map<String, dynamic> filterInputToCriteriaDataMap({
    required IntIdFilterInput filterInput,
  }) {
    return {"idValue": idValue};
  }

  @override
  Future<void> prepareMasterFilterData({
    required IntIdFilterInput? filterInput,
  }) async {
    if (filterInput != null) {
      idValue = filterInput.idValue;
    }
  }

  @override
  Map<String, dynamic> initDefaultFilterCriteria() {
    return {};
  }
}

// -----------------------------------------------------------------------------
