part of '../flutter_artist.dart';

abstract class MasterProp {
  final String propName;
  dynamic candidateUpdateValue;
  bool _valueUpdated = false;
  bool _dirty = false;

  MasterProp({required this.propName});
}
