part of '../flutter_artist.dart';

class _ScalarQueryTaskUnit extends _TaskUnit {
  _XScalar xScalar;

  _ScalarQueryTaskUnit({
    required this.xScalar,
  });

  @override
  String getObjectName() {
    return xScalar.scalar.name;
  }
}
