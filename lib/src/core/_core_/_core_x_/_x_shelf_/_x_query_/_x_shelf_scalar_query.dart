part of '../../../core.dart';

class _XShelfScalarQuery extends _XShelfBaseQuery {
  _XShelfScalarQuery({
    required Scalar scalar,
    required FilterInput? filterInput,
  }) : super(
          xShelfType: XShelfType.scalarQuery,
          shelf: scalar.shelf,
        ) {
    _updateQueryStateFromFilterModelAndFilterInput(
      filterModel: scalar.registeredOrDefaultFilterModel,
      filterInput: filterInput,
      targetBlockAndOptions: null,
      targetScalarAndOptions: TargetScalarAndOptions(
        scalar: scalar,
        queryType: QueryType.realQuery,
      ),
      forceQueryAll: false,
      forceReloadFilter: false,
    );
    printInfo();
  }
}
