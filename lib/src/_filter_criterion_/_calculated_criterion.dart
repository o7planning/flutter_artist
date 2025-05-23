part of '../../flutter_artist.dart';

class CalculatedCriterion<V> extends Criterion<V> {
  final V Function() calculate;

  CalculatedCriterion({
    required super.criterionName,
    required this.calculate,
  });
}
