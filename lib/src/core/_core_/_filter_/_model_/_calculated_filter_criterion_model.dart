part of '../../core.dart';

class CalculatedFilterCriterionModel<V> extends FilterCriterionModel<V> {
  final V Function() calculate;

  CalculatedFilterCriterionModel({
    required super.criterionNameTilde,
    required super.criterionName,
    required this.calculate,
  });
}
