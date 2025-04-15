part of '../flutter_artist.dart';

class MultiOptCriterion extends Criterion {
  late final MultiOptCriterion? parent;

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
  final List<MultiOptCriterion> children;

  MultiOptCriterion({
    required super.criterionName,
    this.children = const [],
  }) : singleSelection = true;

  MultiOptCriterion.multiSelection({
    required super.criterionName,
  })  : singleSelection = false,
        children = [];

  void _checkCycleError() {
    MultiOptCriterion? p = parent;
    final List<String> criterionNames = [criterionName];
    while (true) {
      if (p == null) {
        return;
      }
      if (criterionNames.contains(p.criterionName)) {
        String message = '''
          The parent-child relationship of several criteria forms a cycle.
          ┌─────┐
          |  ${criterionNames.last}
          ↑     ↓
          |  ${p.criterionName}
          └─────┘
        ''';
        throw message;
      }
      criterionNames.add(p.criterionName);
      p = p.parent;
    }
  }

  void _updateTempValueCascade({
    required Map<String, dynamic> updateValues,
  }) {
    if (!_valueUpdated && _markTempDirty) {
      final dynamic oldValue = _tempCurrentValue;
      final dynamic newValue = updateValues[criterionName];
      //
      candidateUpdateValue = newValue;
      _valueUpdated = true;
      //
      bool isSame;
      if (_tempCurrentXData != null) {
        if (singleSelection) {
          isSame = _tempCurrentXData!.isSame(
            item1: oldValue,
            item2: newValue,
          );
        } else {
          isSame = _tempCurrentXData!.isSameItemOrItemList(
            itemOrItemList1: oldValue,
            itemOrItemList2: newValue,
          );
        }
      } else {
        isSame = false;
      }
      //
      if (_tempCurrentXData == null || newValue == null || !isSame) {
        for (MultiOptCriterion childItem in children) {
          childItem._tempCurrentXData = null;
          updateValues[childItem.criterionName] = null;
          childItem._markTempDirty = true;
        }
      }
    }
    //
    for (MultiOptCriterion childItem in children) {
      childItem._updateTempValueCascade(
        updateValues: updateValues,
      );
    }
  }

  void _printTempInfoCascade({required int indentFactor}) {
    print(
        "${("- - - " * indentFactor)} $criterionName >>> UpdateVal: $candidateUpdateValue >>> tempCurrentXData: $_tempCurrentXData");
    for (var child in children) {
      child._printTempInfoCascade(indentFactor: indentFactor + 1);
    }
  }
}
