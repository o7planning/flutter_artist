part of '../core.dart';

class CalculatedFilterCriterion<V> extends FilterCriterion<V> {
  final V Function() calculate;

  CalculatedFilterCriterion({
    required super.criterionNameX,
    required this.calculate,
  });
}
