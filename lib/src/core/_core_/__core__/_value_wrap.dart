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

class PlainValueWrap<VALUE extends Object> {
  final VALUE? value;
  final bool use;

  PlainValueWrap._(this.value, this.use);

  PlainValueWrap.of(this.value) : use = true;

  factory PlainValueWrap.useIfNotNull(VALUE? value) {
    if (value == null) {
      return PlainValueWrap._(value, false);
    }
    return PlainValueWrap._(value, true);
  }

  @override
  String toString() {
    return "PlainValueWrap($value)";
  }
}
