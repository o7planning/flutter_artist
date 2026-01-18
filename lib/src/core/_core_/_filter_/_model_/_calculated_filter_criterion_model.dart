part of '../../core.dart';

class CalculatedFilterCriterionModel<V> extends FilterCriterionModel<V> {
  final V Function() calculate;

  CalculatedFilterCriterionModel({
    required super.criterionNameX,
    required this.calculate,
  });
}
