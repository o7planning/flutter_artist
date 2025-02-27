part of '../flutter_artist.dart';

class _ScalarTaskUnit extends _TaskUnit {
  ScalarTaskUnitName taskUnitName;
  _XScalar xScalar;

  _ScalarTaskUnit({
    required this.xScalar,
    required this.taskUnitName,
  });

  void printInfo() {
    print(
        ">>>>> EXECUTE TaskUnit: $taskUnitName - Scalar: ${xScalar.scalar.name}");
  }
}
