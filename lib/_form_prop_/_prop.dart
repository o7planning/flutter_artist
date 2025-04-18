part of '../flutter_artist.dart';

abstract class Prop {
  late final FormPropsStructure _structure;
  //
  final String propName;
  dynamic candidateUpdateValue;
  bool _valueUpdated = false;
  bool _markTempDirty = false;

  dynamic _tempCurrentValue;
  XData? _tempCurrentXData;

  dynamic _tempInitialValue;
  XData? _tempInitialXData;

  dynamic _currentValue;
  XData? _currentXData;

  dynamic _initialValue;
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
