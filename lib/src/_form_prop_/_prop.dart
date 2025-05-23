part of '../../flutter_artist.dart';

abstract class Prop<V> {
  late final FormPropsStructure _structure;

  //
  final String propName;
  V? _candidateUpdateValue;
  bool _valueUpdated = false;
  bool _markTempDirty = false;

  //

  V? _tempCurrentValue;
  XData? _tempCurrentXData;

  V? _tempInitialValue;
  XData? _tempInitialXData;

  V? _currentValue;
  XData? _currentXData;

  V? _initialValue;
  XData? _initialXData;

  Prop({
    required this.propName,
  });

  bool isDirty() {
    return !_compareDynamicAndDynamic(
      _currentValue,
      _initialValue,
    );
  }
}
