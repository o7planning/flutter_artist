part of '../flutter_artist.dart';

class _DefaultDataFilter
    extends DataFilter<EmptyFilterInput, EmptyFilterCriteria> {
  _DefaultDataFilter({
    required String name,
    required Shelf shelf,
  }) {
    this.name = name;
    this.shelf = shelf;
  }

  @override
  Future<void> prepareData({
    EmptyFilterInput? filterInput,
  }) async {
    // Do nothing
  }

  @override
  List<Restorable> get restorableCriteria => [];

  @override
  EmptyFilterCriteria createFilterCriteria() {
    return EmptyFilterCriteria();
  }
}
