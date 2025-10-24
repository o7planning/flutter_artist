part of '../core.dart';

class CalculatedFilterCriterion<V> extends FilterCriterion<V> {
  final V Function() calculate;

  CalculatedFilterCriterion({
    required super.criterionName,
    required this.calculate,
  });
}
