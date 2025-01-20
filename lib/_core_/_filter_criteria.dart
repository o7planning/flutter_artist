part of '../flutter_artist.dart';

@immutable
abstract class FilterCriteria extends Equatable {
  const FilterCriteria();
}

@immutable
class EmptyFilterCriteria extends FilterCriteria {
  const EmptyFilterCriteria();

  @override
  List<Object?> get props => [];
}
