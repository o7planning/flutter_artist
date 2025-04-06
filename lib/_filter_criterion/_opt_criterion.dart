part of '../flutter_artist.dart';

class OptCriterion extends Criterion {
  OptPropType? type;
  late final OptCriterion? parent;

  ///
  /// In most cases this value is [true].
  /// For example a Dropdown that only allows selection of one element.
  ///
  /// IMPORTANT:
  ///
  /// Make sure you set the appropriate value for this property, otherwise an error will occur.
  /// For example: An error occurs when the library tries to set multiple selection values for the Dropdown.
  ///
  bool singleSelection;
  final List<OptCriterion> children;

  XOptionedData? _xOptionedData;

  XOptionedData? _tempXOptionedData;

  OptCriterion({
    required super.criterionName,
    this.type,
    this.children = const [],
    this.singleSelection = true,
  });

  void _checkCycleError() {
    OptCriterion? p = parent;
    final List<String> propNames = [criterionName];
    while (true) {
      if (p == null) {
        return;
      }
      if (propNames.contains(p.criterionName)) {
        String message = '''
          The parent-child relationship of several properties forms a cycle.
          ┌─────┐
          |  ${propNames.last}
          ↑     ↓
          |  ${p.criterionName}
          └─────┘
        ''';
        throw message;
      }
      propNames.add(p.criterionName);
      p = p.parent;
    }
  }

  void _updateTempValueCascade({
    required Map<String, dynamic> tempCurrentFormData,
    required Map<String, dynamic> updateValues,
  }) {
    if (!_valueUpdated && _dirty) {
      final dynamic oldValue = tempCurrentFormData[criterionName];
      final dynamic newValue = updateValues[criterionName];
      //
      candidateUpdateValue = newValue;
      _valueUpdated = true;
      //
      bool isSame;
      if (_tempXOptionedData != null) {
        if (singleSelection) {
          isSame = _tempXOptionedData!.isSame(item1: oldValue, item2: newValue);
        } else {
          isSame = _tempXOptionedData!.isSameItemOrItemList(
            itemOrItemList1: oldValue,
            itemOrItemList2: newValue,
          );
        }
      } else {
        isSame = false;
      }
      //
      if (_tempXOptionedData == null || newValue == null || !isSame) {
        for (OptCriterion childItem in children) {
          childItem._tempXOptionedData = null;
          updateValues[childItem.criterionName] = null;
          childItem._dirty = true;
        }
      }
    }
    //
    for (OptCriterion childItem in children) {
      childItem._updateTempValueCascade(
        tempCurrentFormData: tempCurrentFormData,
        updateValues: updateValues,
      );
    }
  }

  void _printTempInfoCascade({required int indentFactor}) {
    print(
        "${("- - - " * indentFactor)} $criterionName >>> UpdateV: $candidateUpdateValue >>> tempXOptionedData: $_tempXOptionedData");
    for (var child in children) {
      child._printTempInfoCascade(indentFactor: indentFactor + 1);
    }
  }

  @override
  void _resetForNewTransaction() {
    _tempXOptionedData = null;
  }

  @override
  void _applyTempDataToReal() {
    _xOptionedData = _tempXOptionedData;
  }
}
