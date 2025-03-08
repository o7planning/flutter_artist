part of '../flutter_artist.dart';

class _ScalarQueryTaskUnit extends _TaskUnit {
  _XScalar xScalar;

  _ScalarQueryTaskUnit({
    required this.xScalar,
  });

  @override
  Shelf get shelf => xScalar.scalar.shelf;

  @override
  String getObjectName() {
    return xScalar.scalar.name;
  }
}
