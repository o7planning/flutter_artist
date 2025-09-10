part of '../../core.dart';

class _XShelfScalarQuickExtraDataLoadAction extends XShelf {
  _XShelfScalarQuickExtraDataLoadAction({
    required Scalar scalar,
    required FilterInput? filterInput,
  }) : super(
          xShelfType: XShelfType.scalarQuickExtraDataLoadAction,
          shelf: scalar.shelf,
        ) {
    //
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
