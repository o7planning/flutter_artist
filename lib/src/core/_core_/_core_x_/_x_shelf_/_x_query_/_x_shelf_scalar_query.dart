part of '../../../core.dart';

class _XShelfScalarQuery extends _XShelfBaseQuery {
  _XShelfScalarQuery({
    required Scalar scalar,
    required FilterPatch? filterPatch,
  }) : super(
    xShelfType: XShelfType.scalarQuery,
    shelf: scalar.shelf,
  ) {
    _updateQueryStateFromFilterModelAndFilterPatch(
      filterModel: scalar.registeredOrDefaultFilterModel,
      filterPatch: filterPatch,
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
