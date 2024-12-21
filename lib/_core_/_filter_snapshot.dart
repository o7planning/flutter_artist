part of '../flutter_artist.dart';

abstract class FilterSnapshot extends Equatable {
  const FilterSnapshot();
}

class EmptyFilterSnapshot extends FilterSnapshot {
  @override
  List<Object?> get props => [];
}
