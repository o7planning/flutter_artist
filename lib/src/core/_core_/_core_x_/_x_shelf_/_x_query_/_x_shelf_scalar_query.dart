part of '../../../core.dart';

class _XShelfScalarQuery extends XShelf {
  _XShelfScalarQuery({
    required Scalar scalar,
    required FilterInput? filterInput,
  }) : super(
          xShelfType: XShelfType.scalarQuery,
          shelf: scalar.shelf,
        ) {
    final thisXScalar = xScalarMap[scalar.name]!;
    final xFilterModel = thisXScalar.xFilterModel;
    xFilterModel.filterInput = filterInput;
    //
    thisXScalar.setQueryHint(QryHint.force);
    //
    // IMPORTANT:
    //
    XScalar xScalar = xScalarMap[scalar.name]!;
    setRootVipXScalar(descendantXScalar: xScalar);
  }
}
