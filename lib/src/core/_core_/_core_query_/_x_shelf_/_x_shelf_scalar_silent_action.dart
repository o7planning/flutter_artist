part of '../../core.dart';

class _XShelfScalarSilentAction extends XShelf {
  _XShelfScalarSilentAction({required Scalar scalar})
      : super._(
            xShelfType: XShelfType.scalarSilentAction, shelf: scalar.shelf) {
    //
    // IMPORTANT:
    //
    XScalar xScalar = xScalarMap[scalar.name]!;
    setRootVipXScalar(descendantXScalar: xScalar);
  }
}
