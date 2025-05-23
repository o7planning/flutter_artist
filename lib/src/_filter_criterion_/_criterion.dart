part of '../../flutter_artist.dart';

abstract class Criterion<V> {
  late final FilterCriteriaStructure _structure;

  //

  final String criterionName;

  V? candidateUpdateValue;
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

  //

  Criterion({required this.criterionName});

  bool isDirty() {
    return !_compareDynamicAndDynamic(
      _currentValue,
      _initialValue,
    );
  }
}
