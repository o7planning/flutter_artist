part of '../../core.dart';

class _LazyScalar {
  final Scalar scalar;

  _LazyScalar({required this.scalar});

  String toDebugString() {
    return debugObjHtml(scalar);
  }
}
