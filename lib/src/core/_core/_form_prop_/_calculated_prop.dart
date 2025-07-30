part of '../../_fa_core.dart';

class CalculatedProp<V> extends Prop {
  final V Function() calculate;

  CalculatedProp({
    required super.propName,
    required this.calculate,
  });
}
