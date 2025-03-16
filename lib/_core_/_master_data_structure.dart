part of '../flutter_artist.dart';

class MasterDataStructure {
  final Map<String, MasterProp> _allMasterPropMap = {};
  final List<OptionedMasterProp> _rootOptionedMasterProps;
  final List<CommonMasterProp> _commonMasterProps = [];

  MasterDataStructure({
    required List<OptionedMasterProp> optionedMasterProps,
  }) : _rootOptionedMasterProps = [...optionedMasterProps] {
    for (OptionedMasterProp rootMasterProperty in optionedMasterProps) {
      __standardizeCascade(rootMasterProperty, null);
    }
    for (MasterProp xProperty in _allMasterPropMap.values) {
      if (xProperty is OptionedMasterProp) {
        xProperty._checkCycleError();
      }
    }
  }

  void __standardizeCascade(
    OptionedMasterProp optionedMasterProp,
    OptionedMasterProp? parent,
  ) {
    optionedMasterProp.parent = parent;
    _allMasterPropMap[optionedMasterProp.propName] = optionedMasterProp;
    //
    for (OptionedMasterProp child in optionedMasterProp.children) {
      __standardizeCascade(child, optionedMasterProp);
    }
  }

  Object? _getMasterPropDataCustom(String propName) {
    MasterProp? masterProp = _allMasterPropMap[propName];
    if (masterProp == null) {
      return null;
    }
    if (masterProp is OptionedMasterProp) {
      if (masterProp.type == OptionedMasterPropType.custom) {
        return masterProp._object;
      } else {
        return null;
      }
    }
    return null;
  }

  XList? _getMasterDataXList(String propName) {
    MasterProp? masterProp = _allMasterPropMap[propName];
    if (masterProp == null) {
      return null;
    }
    if (masterProp is OptionedMasterProp) {
      if (masterProp.type == OptionedMasterPropType.listable) {
        return masterProp._xList;
      } else {
        return null;
      }
    }
    return null;
  }

  void _setMasterPropDataXList({
    required String propName,
    required XList? xList,
  }) {
    MasterProp? masterProp = _allMasterPropMap[propName];
    if (masterProp == null) {
      throw AppException(message: 'No MasterProp $propName');
    }
    if (masterProp is OptionedMasterProp) {
      if (masterProp.type != OptionedMasterPropType.listable) {
        throw AppException(
            message: 'Invalid MasterProp Data for type ${masterProp.type}');
      }
      masterProp._xList = xList;
    } else {
      throw AppException(
          message:
              'Invalid MasterProp $propName, it must be $OptionedMasterProp');
    }
  }

  void _setMasterPropDataCustom({
    required String propName,
    required Object? object,
  }) {
    MasterProp? masterProp = _allMasterPropMap[propName];
    if (masterProp == null) {
      throw AppException(message: 'No MasterProp $propName');
    }
    if (masterProp is OptionedMasterProp) {
      if (masterProp.type != OptionedMasterPropType.custom) {
        throw AppException(
            message: 'Invalid MasterProp Data for type ${masterProp.type}');
      }
      masterProp._object = object;
    } else {
      throw AppException(
          message:
              'Invalid MasterProp $propName, it must be $OptionedMasterProp');
    }
  }

  void _addCommonMasterProp(CommonMasterProp masterProp) {
    if (!_allMasterPropMap.containsKey(masterProp.propName)) {
      _allMasterPropMap[masterProp.propName] = masterProp;
      _commonMasterProps.add(masterProp);
    }
  }

  void updateMasterPropValuesToLeaves({
    required Map<String, dynamic> currentValues,
    required Map<String, dynamic> updateValues,
  }) {
    //
    for (MasterProp masterProp in _allMasterPropMap.values) {
      masterProp.updateValue = null;
      masterProp._valueUpdated = false;
      masterProp._dirty = false;
    }
    //
    for (String propName in updateValues.keys) {
      MasterProp? masterProp = _allMasterPropMap[propName];
      if (masterProp != null) {
        masterProp._dirty = true;
      } else {
        CommonMasterProp? newCommonProperty = CommonMasterProp(
          propName: propName,
        );
        newCommonProperty._dirty = true;
        _allMasterPropMap[propName] = newCommonProperty;
        _commonMasterProps.add(newCommonProperty);
      }
    }
    //
    for (OptionedMasterProp rootItem in _rootOptionedMasterProps) {
      rootItem._updateValueCascade(
        currentValues: currentValues,
        updateValues: updateValues,
      );
    }
    for (CommonMasterProp commonItem in _commonMasterProps) {
      commonItem._updateValue(
        currentValues: currentValues,
        updateValues: updateValues,
      );
    }
  }

  void printInfo() {
    print("\n\n--------------------------------------------------------------");
    for (OptionedMasterProp rootItem in _rootOptionedMasterProps) {
      rootItem._printInfoCascade(indentFactor: 1);
    }
    print("--------------------------------------------------------------");
  }
}

abstract class MasterProp {
  final String propName;
  dynamic updateValue;
  bool _valueUpdated = false;
  bool _dirty = false;

  MasterProp({required this.propName});
}

class CommonMasterProp extends MasterProp {
  CommonMasterProp({
    required super.propName,
  });

  void _updateValue({
    required Map<String, dynamic> currentValues,
    required Map<String, dynamic> updateValues,
  }) {
    if (!_valueUpdated && _dirty) {
      final dynamic oldValue = currentValues[propName];
      final dynamic newValue = updateValues[propName];
      //
      updateValue = newValue;
      _valueUpdated = true;
    }
  }
}

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
      updateValue = newValue;
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
        "${("- - - " * indentFactor)} $propName >>> $updateValue >>> ${_xList?.items}");
    for (var child in children) {
      child._printInfoCascade(indentFactor: indentFactor + 1);
    }
  }
}

class MasterPropValueWrap<VALUE> {
  List<VALUE>? value;

  MasterPropValueWrap(List<VALUE>? value) {
    this.value = value?.where((v) => v != null).toList();
  }

  @override
  String toString() {
    return value.toString();
  }
}
