part of '../../core.dart';

class _XShelfScalarClearance extends XShelf {
  _XShelfScalarClearance({required Scalar scalar})
      : super(
          xShelfType: XShelfType.scalarClearance,
          shelf: scalar.shelf,
          resetReactionTypeToExternal: true,
        ) {
    //
    // IMPORTANT:
    //
    XScalar xScalar = xScalarMap[scalar.name]!;
    setRootVipXScalar(descendantXScalar: xScalar);
  }
}
