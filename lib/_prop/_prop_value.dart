part of '../flutter_artist.dart';

class PropValue<VALUE> {
  List<VALUE>? values;

  PropValue.single(VALUE value) {
    values = [value];
  }

  PropValue.multi(List<VALUE> values) {
    values = values;
  }

  // PropValue(List<VALUE>? value) {
  //   this.values = value?.where((v) => v != null).toList();
  // }

  @override
  String toString() {
    return values.toString();
  }
}
