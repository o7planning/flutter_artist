part of '../flutter_artist.dart';

class OptProp extends Prop {
  OptPropType? type;
  late final OptProp? parent;

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
  final List<OptProp> children;

//  XOptionedData? _xOptionedData;

// XOptionedData? _tempXOptionedData;

  OptProp({
    required super.propName,
    this.type,
    this.children = const [],
    this.singleSelection = true,
  });

  void _checkCycleError() {
    OptProp? p = parent;
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
    required Map<String, dynamic> tempCurrentFormData,
    required Map<String, dynamic> updateValues,
  }) {
    if (!_valueUpdated && _markTempDirty) {
      final dynamic oldValue = tempCurrentFormData[propName];
      final dynamic newValue = updateValues[propName];
      //
      candidateUpdateValue = newValue;
      _valueUpdated = true;
      //
      bool isSame;
      if (_tempCurrentXData != null) {
        if (singleSelection) {
          isSame = _tempCurrentXData!.isSame(item1: oldValue, item2: newValue);
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
        for (OptProp childItem in children) {
          childItem._tempCurrentXData = null;
          updateValues[childItem.propName] = null;
          childItem._markTempDirty = true;
        }
      }
    }
    //
    for (OptProp childItem in children) {
      childItem._updateTempValueCascade(
        tempCurrentFormData: tempCurrentFormData,
        updateValues: updateValues,
      );
    }
  }

  void _printTempInfoCascade({required int indentFactor}) {
    print(
        "${("- - - " * indentFactor)} $propName >>> UpdateV: $candidateUpdateValue >>> tempXOptionedData: $_tempCurrentXData");
    for (var child in children) {
      child._printTempInfoCascade(indentFactor: indentFactor + 1);
    }
  }
}
