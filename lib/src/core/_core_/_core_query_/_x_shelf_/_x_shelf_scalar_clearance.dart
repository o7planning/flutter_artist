part of '../../core.dart';

class _XShelfScalarClearance extends XShelf {
  _XShelfScalarClearance({required Scalar scalar})
      : super._(
          xShelfType: XShelfType.scalarClearance,
          shelf: scalar.shelf,
        ) {
    //
    // IMPORTANT:
    //
    XScalar xScalar = xScalarMap[scalar.name]!;
    setRootVipXScalar(descendantXScalar: xScalar);
  }
}
