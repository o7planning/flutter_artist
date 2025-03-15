part of '../flutter_artist.dart';

class MasterDataStructure {
  final Map<String, MasterProp> _masterPropMap = {};
  final List<OptionedMasterProp> _rootOptionedMasterProps;
  final List<CommonMasterProp> _commonMasterProps = [];

  MasterDataStructure({
    required List<OptionedMasterProp> optionedMasterProps,
  }) : _rootOptionedMasterProps = [...optionedMasterProps] {
    for (OptionedMasterProp rootMasterProperty in optionedMasterProps) {
      __standardizeCascade(rootMasterProperty, null);
    }
    for (MasterProp xProperty in _masterPropMap.values) {
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
    _masterPropMap[optionedMasterProp.propName] = optionedMasterProp;
    //
    for (OptionedMasterProp child in optionedMasterProp.children) {
      __standardizeCascade(child, optionedMasterProp);
    }
  }

  Object? _getMasterPropDataCustom(String propName) {
    MasterProp? masterProp = _masterPropMap[propName];
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
    MasterProp? masterProp = _masterPropMap[propName];
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
    MasterProp? masterProp = _masterPropMap[propName];
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
    MasterProp? masterProp = _masterPropMap[propName];
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
    if (!_masterPropMap.containsKey(masterProp.propName)) {
      _masterPropMap[masterProp.propName] = masterProp;
      _commonMasterProps.add(masterProp);
    }
  }

  void updateValues({
    required Map<String, dynamic> currentValues,
    required Map<String, dynamic> updateValues,
  }) {
    // Clean all TreeItem in Tree.
    for (MasterProp masterProp in _masterPropMap.values) {
      masterProp.updateValue = null;
      masterProp._valueUpdated = false;
      masterProp._dirty = false;
    }
    //
    for (String prop in updateValues.keys) {
      MasterProp? item = _masterPropMap[prop];
      if (item != null) {
        item._dirty = true;
      } else {
        CommonMasterProp? newCommonProperty = CommonMasterProp(
          propName: prop,
        );
        newCommonProperty._dirty = true;
        _masterPropMap[prop] = newCommonProperty;
        _commonMasterProps.add(newCommonProperty);
      }
    }
    //
    for (OptionedMasterProp rootItem in _rootOptionedMasterProps) {
      rootItem._updateValueCascase(
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

  void _updateValueCascase({
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
      if (_xList == null) {
        return;
      }
      bool isSame = _xList!.isSame(item1: oldValue, item2: newValue);
      if (!isSame || newValue == null) {
        for (OptionedMasterProp childItem in children) {
          if (childItem._xList != null) {
            childItem._xList!.clear();
            childItem._xList = null;
            updateValues[childItem.propName] = null;
            childItem._dirty = true;
          }
        }
      }
    }
    //
    for (OptionedMasterProp childItem in children) {
      childItem._updateValueCascase(
        currentValues: currentValues,
        updateValues: updateValues,
      );
    }
  }
}
