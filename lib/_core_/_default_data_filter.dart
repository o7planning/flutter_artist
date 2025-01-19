part of '../flutter_artist.dart';

class _DefaultDataFilter
    extends DataFilter<EmptyFilterData, EmptyFilterSnapshot> {
  _DefaultDataFilter({
    required String name,
    required Shelf shelf,
  }) {
    this.name = name;
    this.shelf = shelf;
  }

  @override
  Future<void> prepareData({
    EmptyFilterData? suggestedFilterData,
  }) async {
    // Do nothing
  }

  @override
  List<Restorable> get restorableCriteria => [];

  @override
  EmptyFilterSnapshot takeSnapshot() {
    return EmptyFilterSnapshot();
  }
}
