part of '../core.dart';

class OptValueWrap<VALUE extends Object> {
  List<VALUE?> values = [];

  OptValueWrap.single(VALUE? value) {
    if (value == null) {
      values = [];
    } else {
      values = [value];
    }
  }

  OptValueWrap.multi(List<VALUE?> values) {
    this.values = values.where((v) => v != null).toList();
  }

  @override
  String toString() {
    return values.toString();
  }
}

class SimpleValueWrap<VALUE extends Object> {
  final VALUE? value;

  SimpleValueWrap(this.value);

  static SimpleValueWrap<VALUE>? useIfNotNull<VALUE extends Object>(
      VALUE? value) {
    if (value == null) {
      return null;
    }
    return SimpleValueWrap(value);
  }

  @override
  String toString() {
    return "SimpleValueWrap($value)";
  }
}
