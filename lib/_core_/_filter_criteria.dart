part of '../flutter_artist.dart';

abstract class FilterCriteria extends Equatable {
  const FilterCriteria();
}

class EmptyFilterCriteria extends FilterCriteria {
  @override
  List<Object?> get props => [];
}
