part of '../../core.dart';

class _XShelfScalarBackendAction extends XShelf {
  _XShelfScalarBackendAction({
    required Scalar scalar,
  }) : super(
    xShelfType: XShelfType.scalarBackendAction,
    shelf: scalar.shelf,
  ) {
    //
  }
}
