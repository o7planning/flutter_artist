part of '../_fa_core.dart';

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
    return "${getClassName(this)}(${getClassName(scalar)}))";
  }
}
