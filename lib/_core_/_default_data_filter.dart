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
  Future<void> prepareData({
    EmptyFilterInput? filterInput,
  }) async {
    // Do nothing
  }

  @override
  List<Restorable> get restorableCriteria => [];

  @override
  EmptyFilterCriteria createFilterCriteria() {
    return EmptyFilterCriteria();
  }
}

// -----------------------------------------------------------------------------

class StringIdDataFilter
    extends DataFilter<StringIdFilterInput, StringIdFilterCriteria> {
  String? idValue;

  StringIdDataFilter({required this.idValue});

  @override
  StringIdFilterCriteria createFilterCriteria() {
    return StringIdFilterCriteria(idValue: idValue);
  }

  @override
  Future<void> prepareData({StringIdFilterInput? filterInput}) async {
    if (filterInput != null) {
      idValue = filterInput.idValue;
    }
  }

  @override
  List<Restorable> get restorableCriteria => [];
}

// -----------------------------------------------------------------------------

class StringValueDataFilter
    extends DataFilter<StringValueFilterInput, StringValueFilterCriteria> {
  String? stringValue;

  StringValueDataFilter({required this.stringValue});

  @override
  StringValueFilterCriteria createFilterCriteria() {
    return StringValueFilterCriteria(stringValue: stringValue);
  }

  @override
  Future<void> prepareData({StringValueFilterInput? filterInput}) async {
    if (filterInput != null) {
      stringValue = filterInput.stringValue;
    }
  }

  @override
  List<Restorable> get restorableCriteria => [];
}

// -----------------------------------------------------------------------------

class SearchTextDataFilter
    extends DataFilter<SearchTextFilterInput, SearchTextFilterCriteria> {
  String? searchText;

  SearchTextDataFilter({required this.searchText});

  @override
  SearchTextFilterCriteria createFilterCriteria() {
    return SearchTextFilterCriteria(searchText: searchText);
  }

  @override
  Future<void> prepareData({SearchTextFilterInput? filterInput}) async {
    if (filterInput != null) {
      searchText = filterInput.searchText;
    }
  }

  @override
  List<Restorable> get restorableCriteria => [];
}

// -----------------------------------------------------------------------------

class IntIdDataFilter
    extends DataFilter<IntIdFilterInput, IntIdFilterCriteria> {
  int? idValue;

  IntIdDataFilter({required this.idValue});

  @override
  IntIdFilterCriteria createFilterCriteria() {
    return IntIdFilterCriteria(idValue: idValue);
  }

  @override
  Future<void> prepareData({IntIdFilterInput? filterInput}) async {
    if (filterInput != null) {
      idValue = filterInput.idValue;
    }
  }

  @override
  List<Restorable> get restorableCriteria => [];
}

// -----------------------------------------------------------------------------
