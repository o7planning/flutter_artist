part of '../code.dart';

abstract class FilterInput {
  const FilterInput();
}

// -----------------------------------------------------------------------------

class EmptyFilterInput extends FilterInput {
  const EmptyFilterInput();
}

// -----------------------------------------------------------------------------

class StringIdFilterInput extends FilterInput {
  final String? idValue;

  StringIdFilterInput({required this.idValue});
}

// -----------------------------------------------------------------------------

class StringValueFilterInput extends FilterInput {
  final String? stringValue;

  StringValueFilterInput({required this.stringValue});
}

// -----------------------------------------------------------------------------

class SearchTextFilterInput extends FilterInput {
  final String? searchText;

  SearchTextFilterInput({required this.searchText});
}

// -----------------------------------------------------------------------------

class IntIdFilterInput extends FilterInput {
  final int? idValue;

  IntIdFilterInput({required this.idValue});
}

// -----------------------------------------------------------------------------
