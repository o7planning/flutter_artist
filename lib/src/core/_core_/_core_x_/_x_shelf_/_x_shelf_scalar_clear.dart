part of '../../core.dart';

class _XShelfScalarClear extends XShelf {
  _XShelfScalarClear({
    required Scalar scalar,
  }) : super(
    xShelfType: XShelfType.scalarClear,
    shelf: scalar.shelf,
  ) {
    //
  }
}
