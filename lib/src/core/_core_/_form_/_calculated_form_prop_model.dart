part of '../core.dart';

class CalculatedFormPropModel<V> extends FormPropModel {
  final V Function() calculate;

  CalculatedFormPropModel({
    required super.propName,
    required this.calculate,
  });
}
