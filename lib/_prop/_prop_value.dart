part of '../flutter_artist.dart';

class PropValue<VALUE extends Object> {
  List<VALUE?> values = [];

  PropValue.single(VALUE? value) {
    if (value == null) {
      this.values = [];
    } else {
      this.values = [value];
    }
  }

  PropValue.multi(List<VALUE?> values) {
    this.values = values.where((v) => v != null).toList();
  }

  // PropValue(List<VALUE>? value) {
  //   this.values = value?.where((v) => v != null).toList();
  // }

  @override
  String toString() {
    return values.toString();
  }
}
