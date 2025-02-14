part of '../flutter_artist.dart';

abstract class FilterInput {
  const FilterInput();
}

// -----------------------------------------------------------------------------

class EmptyFilterInput extends FilterInput {
  const EmptyFilterInput();
}

// -----------------------------------------------------------------------------

class StringIdFilterInput extends FilterInput {
  String idValue;

  StringIdFilterInput({required this.idValue});
}

// -----------------------------------------------------------------------------

class StringValueFilterInput extends FilterInput {
  String stringValue;

  StringValueFilterInput({required this.stringValue});
}


// -----------------------------------------------------------------------------

class SearchTextFilterInput extends FilterInput {
  String? searchText;

  SearchTextFilterInput({required this.searchText});
}

// -----------------------------------------------------------------------------

class IntIdFilterInput extends FilterInput {
  int idValue;

  IntIdFilterInput({required this.idValue});
}
