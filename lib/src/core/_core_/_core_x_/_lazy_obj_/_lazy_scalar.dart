part of '../../core.dart';

class _LazyScalar {
  final Scalar scalar;

  _LazyScalar({required this.scalar});

  @override
  String toString() {
    return "(${scalar.name})";
  }
}
