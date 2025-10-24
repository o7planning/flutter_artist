part of '../core.dart';

class CalculatedFormProp<V> extends FormProp {
  final V Function() calculate;

  CalculatedFormProp({
    required super.propName,
    required this.calculate,
  });
}
