part of '../../../core.dart';

class _XShelfFilterModelQueryAll extends _XShelfSbQuery {
  _XShelfFilterModelQueryAll({
    required FilterModel filterModel,
    required FilterInput? filterInput,
  }) : super(
          xShelfType: XShelfType.filterModelQueryAll,
          shelf: filterModel.shelf,
        ) {
    _updateQueryStateFromFilterModelAndFilterInput(
      filterModel: filterModel,
      filterInput: filterInput,
      srcBlockAndOptions: null,
      srcScalarAndOptions: null,
    );
  }
}
