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
  final bool use;

  SimpleValueWrap._(this.value, this.use);

  SimpleValueWrap.of(this.value) : use = true;

  factory SimpleValueWrap.useIfNotNull(VALUE? value) {
    if (value == null) {
      return SimpleValueWrap._(value, false);
    }
    return SimpleValueWrap._(value, true);
  }

  @override
  String toString() {
    return "SimpleValueWrap($value)";
  }
}
