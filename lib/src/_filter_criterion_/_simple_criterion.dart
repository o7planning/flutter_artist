part of '../../flutter_artist.dart';

class SimpleCriterion<V> extends Criterion<V> {
  SimpleCriterion({
    required super.criterionName,
  });

  static List<SimpleCriterion> listFromNames(List<String> criterionNames) {
    return criterionNames
        .map(
          (name) => SimpleCriterion(criterionName: name),
        )
        .toList();
  }

  void _updateTempValue({
    required Map<String, dynamic> updateValues,
  }) {
    if (!_valueUpdated && _markTempDirty) {
      // final dynamic oldValue = _tempCurrentValue;
      final dynamic newValue = updateValues[criterionName];
      //
      candidateUpdateValue = newValue;
      _valueUpdated = true;
    }
  }
}
