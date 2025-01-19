part of '../flutter_artist.dart';

abstract class EmptyFilterCriteria extends Equatable {
  const EmptyFilterCriteria();
}

class EmptyEmptyFilterCriteria extends EmptyFilterCriteria {
  @override
  List<Object?> get props => [];
}
