part of '../flutter_artist.dart';

///
/// Scalar with Query Options
///
class _ScalarOpt {
  final Scalar scalar;

  _ScalarOpt({
    required this.scalar,
  });

  @override
  String toString() {
    return "${getClassName(this)}(${scalar.name})";
  }
}
