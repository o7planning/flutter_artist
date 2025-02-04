part of '../flutter_artist.dart';

@immutable
abstract class FilterCriteria extends Equatable {
  const FilterCriteria();

  List<String> getDebugInfos();
}

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
