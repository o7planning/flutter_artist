part of '../code.dart';

class CalculatedCriterion<V> extends Criterion<V> {
  final V Function() calculate;

  CalculatedCriterion({
    required super.criterionName,
    required this.calculate,
  });
}
