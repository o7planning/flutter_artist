part of '../flutter_artist.dart';

abstract class _TaskUnit {
  String getTaskUnitId() {
    return "${getClassName(this)}/${getObjectName()}";
  }

  int get xShelfId;

  String getObjectName();

  Shelf get shelf;
}
