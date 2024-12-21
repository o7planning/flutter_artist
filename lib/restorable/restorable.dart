abstract class Restorable<D> {
  D _value;
  late D _lastValue;

  Restorable(D value) : _value = value {
    _lastValue = copy(_value);
  }

  D get value => _value;

  set value(D newValue) {
    _value = newValue;
  }

  D get lastValue => _lastValue;

  void restore() {
    _value = copy(_lastValue);
  }

  void applyNewState() {
    _lastValue = copy(_value);
  }

  D copy(D value);
}
