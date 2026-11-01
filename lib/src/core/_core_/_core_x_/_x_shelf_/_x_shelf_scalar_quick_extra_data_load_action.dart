part of '../../core.dart';

class _XShelfScalarQuickExtraDataLoadAction extends XShelf {
  _XShelfScalarQuickExtraDataLoadAction({
    required Scalar scalar,
    required FilterPatch? filterPatch,
  }) : super(
          xShelfType: XShelfType.scalarQuickExtraDataLoadAction,
          shelf: scalar.shelf,
        ) {
    //
    final thisXScalar = xScalarMap[scalar.name]!;
    final xFilterModel = thisXScalar.xFilterModel;
    xFilterModel.filterPatch = filterPatch;
    //
    thisXScalar.setQueryHintToGreater(QueryHint.force);
  }
}
