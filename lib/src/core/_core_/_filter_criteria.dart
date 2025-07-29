part of '../_fa_core.dart';

@immutable
abstract class FilterCriteria extends Equatable {
  const FilterCriteria();

  List<String> getDebugInfos();
}

// -----------------------------------------------------------------------------

@immutable
class EmptyFilterCriteria extends FilterCriteria {
  const EmptyFilterCriteria();

  @override
  List<String> getDebugInfos() {
    return [];
  }

  @override
  List<Object?> get props => [];
}

// -----------------------------------------------------------------------------

class StringIdFilterCriteria extends FilterCriteria {
  final String? idValue;

  const StringIdFilterCriteria({required this.idValue});

  @override
  List<String> getDebugInfos() {
    return ["idValue: $idValue"];
  }

  @override
  List<Object?> get props => [idValue];
}

// -----------------------------------------------------------------------------

class StringValueFilterCriteria extends FilterCriteria {
  final String? stringValue;

  const StringValueFilterCriteria({required this.stringValue});

  @override
  List<String> getDebugInfos() {
    return ["stringValue: $stringValue"];
  }

  @override
  List<Object?> get props => [stringValue];
}

// -----------------------------------------------------------------------------
///
/// An empty or null searchText is considered the same.
///
class SearchTextFilterCriteria extends FilterCriteria {
  final String? searchText;

  const SearchTextFilterCriteria({required this.searchText});

  @override
  List<String> getDebugInfos() {
    return ["searchText: $searchText"];
  }

  @override
  List<Object?> get props => [
        _stringToNullIfEmpty(searchText),
      ];
}

// -----------------------------------------------------------------------------

class IntIdFilterCriteria extends FilterCriteria {
  final int? idValue;

  const IntIdFilterCriteria({required this.idValue});

  @override
  List<String> getDebugInfos() {
    return ["idValue: $idValue"];
  }

  @override
  List<Object?> get props => [idValue];
}

// -----------------------------------------------------------------------------
