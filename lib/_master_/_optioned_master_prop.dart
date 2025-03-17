part of '../flutter_artist.dart';

class OptionedMasterProp extends MasterProp {
  late final OptionedMasterProp? parent;

  ///
  /// In most cases this value is [true].
  /// For example a Dropdown that only allows selection of one element.
  ///
  /// IMPORTANT:
  ///
  /// Make sure you set the appropriate value for this property, otherwise an error will occur.
  /// For example: An error occurs when the library tries to set multiple selection values for the Dropdown.
  ///
  final bool singleSelection;
  final List<OptionedMasterProp> children;
  final OptionedMasterPropType type;
  XList? _xList;
  Object? _object;

  OptionedMasterProp({
    required super.propName,
    required this.type,
    this.singleSelection = true,
    this.children = const [],
  });

  void _checkCycleError() {
    OptionedMasterProp? p = parent;
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

  void _updateValueCascade({
    required Map<String, dynamic> currentValues,
    required Map<String, dynamic> updateValues,
  }) {
    if (!_valueUpdated && _dirty) {
      final dynamic oldValue = currentValues[propName];
      final dynamic newValue = updateValues[propName];
      //
      candidateUpdateValue = newValue;
      _valueUpdated = true;
      //
      bool isSame;
      if (_xList != null) {
        isSame = _xList!.isSame(item1: oldValue, item2: newValue);
      } else {
        isSame = false;
      }
      //
      if (_xList == null || newValue == null || !isSame) {
        for (OptionedMasterProp childItem in children) {
          childItem._xList = null;
          updateValues[childItem.propName] = null;
          childItem._dirty = true;
        }
      }
    }
    //
    for (OptionedMasterProp childItem in children) {
      childItem._updateValueCascade(
        currentValues: currentValues,
        updateValues: updateValues,
      );
    }
  }

  void _printInfoCascade({required int indentFactor}) {
    print(
        "${("- - - " * indentFactor)} $propName >>> $candidateUpdateValue >>> ${_xList?.items}");
    for (var child in children) {
      child._printInfoCascade(indentFactor: indentFactor + 1);
    }
  }
}
