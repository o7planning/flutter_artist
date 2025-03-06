part of '../flutter_artist.dart';

abstract class _TaskUnit {
  String getTaskUnitId() {
    return "${getClassName(this)}/${getObjectName()}";
  }

  String getObjectName();
}
