part of '../../flutter_artist.dart';

class CalculatedProp<V> extends Prop {
  final V Function() calculate;

  CalculatedProp({
    required super.propName,
    required this.calculate,
  });
}
