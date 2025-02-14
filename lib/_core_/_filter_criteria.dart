part of '../flutter_artist.dart';

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
  final String idValue;

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
  final String stringValue;

  const StringValueFilterCriteria({required this.stringValue});

  @override
  List<String> getDebugInfos() {
    return ["stringValue: $stringValue"];
  }

  @override
  List<Object?> get props => [stringValue];
}

// -----------------------------------------------------------------------------

String? _toNullValueIfCan(String? s) {
  if (s == null) {
    return null;
  }
  String s1 = s.trim();
  return s1.isEmpty ? null : s1;
}

class SearchTextFilterCriteria extends FilterCriteria {
  final String? _searchText;

  SearchTextFilterCriteria({required String? searchText})
      : _searchText = _toNullValueIfCan(searchText);

  @override
  List<String> getDebugInfos() {
    return ["searchText: $_searchText"];
  }

  @override
  List<Object?> get props => [_searchText];
}

// -----------------------------------------------------------------------------

class IntIdFilterCriteria extends FilterCriteria {
  final int idValue;

  const IntIdFilterCriteria({required this.idValue});

  @override
  List<String> getDebugInfos() {
    return ["idValue: $idValue"];
  }

  @override
  List<Object?> get props => [idValue];
}
