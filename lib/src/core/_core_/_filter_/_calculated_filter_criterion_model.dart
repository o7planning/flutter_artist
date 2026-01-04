part of '../core.dart';

class CalculatedFilterCriterionModel<V> extends FilterCriterionModel<V> {
  final V Function() calculate;

  CalculatedFilterCriterionModel({
    required super.criterionName,
    required this.calculate,
    required super.operator,
    super.description,
  });
}
