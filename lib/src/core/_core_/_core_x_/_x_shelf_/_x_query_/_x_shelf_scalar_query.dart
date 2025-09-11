part of '../../../core.dart';

class _XShelfScalarQuery extends _XShelfSbQuery {
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
      srcBlockAndOptions: null,
      srcScalarAndOptions: SrcScalarAndOptions(
        scalar: scalar,
        queryType: QueryType.realQuery,
      ),
    );
    //
    // Replace:
    //
    final XScalar thisXScalar = xScalarMap[scalar.name]!;
    final XFilterModel xFilterModel = thisXScalar.xFilterModel;
    xFilterModel.filterInput = filterInput;
    //
    thisXScalar.setQueryHintToGreater(QryHint.force);
    //
    // IMPORTANT:
    //
    setRootVipXScalar(descendantXScalar: thisXScalar);
  }
}
