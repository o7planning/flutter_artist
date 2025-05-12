part of '../../flutter_artist.dart';

class MultiOptProp extends Prop {
  late final MultiOptProp? parent;
  final MultiOptPropReload reloadCondition;

  bool _markToReload = false;
  int _loadCount = 0;

  int get loadCount => _loadCount;

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
  final List<MultiOptProp> children;

  MultiOptProp({
    required super.propName,
    this.reloadCondition = MultiOptPropReload.ifCriteriaChanged,
    this.children = const [],
  }) : singleSelection = true;

  MultiOptProp.multiSelection({
    required super.propName,
    this.reloadCondition = MultiOptPropReload.ifCriteriaChanged,
  })  : singleSelection = false,
        children = const [];

  void _checkCycleError() {
    MultiOptProp? p = parent;
    final List<String> propNames = [propName];
    while (true) {
      if (p == null) {
        return;
      }
      if (propNames.contains(p.propName)) {
        String message = '''
          The parent-child relationship of several properties forms a cycle.
          ┌─────┐
          |  ${propNames.last}
          ↑     ↓
          |  ${p.propName}
          └─────┘
        ''';
        throw message;
      }
      propNames.add(p.propName);
      p = p.parent;
    }
  }

  void _updateTempValueCascade({
    required Map<String, dynamic> updateValues,
  }) {
    if (!_valueUpdated && _markTempDirty) {
      final dynamic oldValue = _tempCurrentValue;
      final dynamic newValue = updateValues[propName];
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
        for (MultiOptProp childItem in children) {
          childItem._tempCurrentXData = null;
          updateValues[childItem.propName] = null;
          childItem._markTempDirty = true;
        }
      }
    }
    //
    for (MultiOptProp childItem in children) {
      childItem._updateTempValueCascade(
        updateValues: updateValues,
      );
    }
  }

  void _printTempInfoCascade({required int indentFactor}) {
    print(
        "${("- - - " * indentFactor)} $propName >>> UpdateVal: $candidateUpdateValue >>> tempCurrentXData: $_tempCurrentXData");
    for (var child in children) {
      child._printTempInfoCascade(indentFactor: indentFactor + 1);
    }
  }
}
