part of '../../core.dart';

class _XShelfScalarClearValue extends XShelf {
  _XShelfScalarClearValue({
    required Scalar scalar,
  }) : super(
    xShelfType: XShelfType.scalarClearValue,
    shelf: scalar.shelf,
  ) {
    //
  }
}
