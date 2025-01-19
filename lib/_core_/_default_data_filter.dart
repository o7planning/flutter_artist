part of '../flutter_artist.dart';

class _DefaultDataFilter
    extends DataFilter<EmptySuggestedCriteria, EmptyEmptyFilterCriteria> {
  _DefaultDataFilter({
    required String name,
    required Shelf shelf,
  }) {
    this.name = name;
    this.shelf = shelf;
  }

  @override
  Future<void> prepareData({
    EmptySuggestedCriteria? suggestedCriteria,
  }) async {
    // Do nothing
  }

  @override
  List<Restorable> get restorableCriteria => [];

  @override
  EmptyEmptyFilterCriteria createCriteria() {
    return EmptyEmptyFilterCriteria();
  }
}
