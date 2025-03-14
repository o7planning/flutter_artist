part of '../flutter_artist.dart';

class MasterDataStructure {
  final Map<String, MasterProp> _masterPropMap = {};
  final List<RelatedMasterProp> _rootRelatedMasterProps;
  final List<CommonMasterProp> _commonProperties = [];

  MasterDataStructure({
    required List<RelatedMasterProp> relatedMasterProps,
  }) : _rootRelatedMasterProps = [...relatedMasterProps] {
    for (RelatedMasterProp rootMasterProperty in relatedMasterProps) {
      __standardizeCascade(rootMasterProperty, null);
    }
    for (MasterProp xProperty in _masterPropMap.values) {
      if (xProperty is RelatedMasterProp) {
        xProperty._checkCycleError();
      }
    }
  }

  void __standardizeCascade(
    RelatedMasterProp relatedMasterProp,
    RelatedMasterProp? parent,
  ) {
    relatedMasterProp.parent = parent;
    _masterPropMap[relatedMasterProp.propName] = relatedMasterProp;
    //
    for (RelatedMasterProp child in relatedMasterProp.children) {
      __standardizeCascade(child, relatedMasterProp);
    }
  }

  XList? _getXListMasterData(String propName) {
    MasterProp? xProperty = _masterPropMap[propName];
    if (xProperty == null) {
      return null;
    }
    if (xProperty is RelatedMasterProp) {
      return xProperty._xList;
    }
    return null;
  }

  void _setXListMasterData({required String propName, required XList? xList}) {
    MasterProp? masterProp = _masterPropMap[propName];
    if (masterProp == null) {
      throw AppException(message: 'No MasterProp $propName');
    }
    if (masterProp is RelatedMasterProp) {
      masterProp._xList = xList;
    } else {
      throw AppException(message: 'Invalid MasterProp $propName');
    }
  }

  void _addCommonMasterProp(CommonMasterProp masterProp) {
    if (!_masterPropMap.containsKey(masterProp.propName)) {
      _masterPropMap[masterProp.propName] = masterProp;
      _commonProperties.add(masterProp);
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
        _commonProperties.add(newCommonProperty);
      }
    }
    //
    for (RelatedMasterProp rootItem in _rootRelatedMasterProps) {
      rootItem._updateValueCascase(
        currentValues: currentValues,
        updateValues: updateValues,
      );
    }
    for (CommonMasterProp commonItem in _commonProperties) {
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

class RelatedMasterProp extends MasterProp {
  late final RelatedMasterProp? parent;
  final List<RelatedMasterProp> children;
  XList? _xList;

  RelatedMasterProp({
    required super.propName,
    this.children = const [],
  });

  void _checkCycleError() {
    RelatedMasterProp? p = parent;
    List<String> propNames = [propName];
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
        for (RelatedMasterProp childItem in children) {
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
    for (RelatedMasterProp childItem in children) {
      childItem._updateValueCascase(
        currentValues: currentValues,
        updateValues: updateValues,
      );
    }
  }
}
