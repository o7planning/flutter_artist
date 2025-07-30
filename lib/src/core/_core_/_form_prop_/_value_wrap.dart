part of '../core.dart';

class ValueWrap<VALUE extends Object> {
  List<VALUE?> values = [];

  ValueWrap.single(VALUE? value) {
    if (value == null) {
      this.values = [];
    } else {
      this.values = [value];
    }
  }

  ValueWrap.multi(List<VALUE?> values) {
    this.values = values.where((v) => v != null).toList();
  }

  @override
  String toString() {
    return values.toString();
  }
}
