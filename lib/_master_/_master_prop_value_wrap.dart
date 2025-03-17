part of '../flutter_artist.dart';

class MasterPropValueWrap<VALUE> {
  List<VALUE>? value;

  MasterPropValueWrap(List<VALUE>? value) {
    this.value = value?.where((v) => v != null).toList();
  }

  @override
  String toString() {
    return value.toString();
  }
}
