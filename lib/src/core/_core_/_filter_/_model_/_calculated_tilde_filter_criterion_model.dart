part of '../../core.dart';

class CalculatedTildeFilterCriterionModel<V>
    extends TildeFilterCriterionModel<V> {
  final V Function() calculate;

  CalculatedTildeFilterCriterionModel({
    required super.tildeCriterionName,
    required super.criterionName,
    required this.calculate,
  });
}
