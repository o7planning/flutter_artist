part of '../flutter_artist.dart';

class PropValue<VALUE> {
  List<VALUE>? value;

  PropValue(List<VALUE>? value) {
    this.value = value?.where((v) => v != null).toList();
  }

  @override
  String toString() {
    return value.toString();
  }
}
