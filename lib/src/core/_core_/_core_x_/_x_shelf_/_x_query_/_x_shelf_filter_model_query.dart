part of '../../../core.dart';

class _XShelfFilterModelQuery extends _XShelfBaseQuery {
  _XShelfFilterModelQuery({
    required FilterModel filterModel,
    required FilterInput? filterInput,
    required bool forceQueryAll,
  }) : super(
          xShelfType: XShelfType.filterModelQuery,
          shelf: filterModel.shelf,
        ) {
    _updateQueryStateFromFilterModelAndFilterInput(
      filterModel: filterModel,
      filterInput: filterInput,
      srcBlockAndOptions: null,
      srcScalarAndOptions: null,
      forceQueryAll: forceQueryAll,
    );
  }
}
