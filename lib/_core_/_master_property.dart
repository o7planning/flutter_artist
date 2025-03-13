part of '../flutter_artist.dart';

class MasterProperties {
  final Map<String, XProperty> _xPropMap = {};
  final List<XProperty> rootXProperties;

  MasterProperties({
    required List<MasterProperty> masterProperties,
  }) : rootXProperties = [...masterProperties] {
    for (MasterProperty rootMasterProperty in masterProperties) {
      __standardizeCascade(rootMasterProperty, null);
    }
    for (XProperty xProperty in _xPropMap.values) {
      if (xProperty is MasterProperty) {
        xProperty._checkCycleError();
      }
    }
  }

  void __standardizeCascade(
    MasterProperty masterProperty,
    MasterProperty? parent,
  ) {
    masterProperty.parent = parent;
    _xPropMap[masterProperty.propName] = masterProperty;
    //
    for (MasterProperty child in masterProperty.children) {
      __standardizeCascade(child, masterProperty);
    }
  }

  XList? getXList(String propName) {
    XProperty? xProperty = _xPropMap[propName];
    if (xProperty == null) {
      return null;
    }
    if (xProperty is MasterProperty) {
      return xProperty.xList;
    }
    return null;
  }

  void setXList({required String property, required XList? xList}) {
    XProperty? xProperty = _xPropMap[property];
    if (xProperty == null) {
      throw AppException(message: 'No Master Property $property');
    }
    if (xProperty is MasterProperty) {
      xProperty.xList = xList;
    } else {
      throw AppException(message: 'Invalid Master Property $property');
    }
  }

  void addOptProperty(OptProperty property) {
    if (!_xPropMap.containsKey(property.propName)) {
      _xPropMap[property.propName] = property;
      rootXProperties.add(property);
    }
  }

  void updateValues({
    required Map<String, dynamic> currentValues,
    required Map<String, dynamic> updateValues,
  }) {
    // Clean all TreeItem in Tree.
    for (XProperty xProperty in _xPropMap.values) {
      xProperty.updateValue = null;
      xProperty.valueUpdated = false;
      xProperty.dirty = false;
    }
    //
    for (String prop in updateValues.keys) {
      XProperty? item = _xPropMap[prop];
      if (item != null) {
        item.dirty = true;
      } else {
        OptProperty? newXProperty = OptProperty(
          propName: prop,
        );
        newXProperty.dirty = true;
        _xPropMap[prop] = newXProperty;
        rootXProperties.add(newXProperty);
      }
    }
    //
    for (XProperty rootItem in rootXProperties) {
      if (rootItem is MasterProperty) {
        rootItem.updateValueCascase(
          currentValues: currentValues,
          updateValues: updateValues,
        );
      } else if (rootItem is OptProperty) {
        rootItem.updateValueCascade(
          currentValues: currentValues,
          updateValues: updateValues,
        );
      }
    }
  }
}

abstract class XProperty {
  final String propName;
  dynamic updateValue;
  bool valueUpdated = false;
  bool dirty = false;

  XProperty({required this.propName});
}

class OptProperty extends XProperty {
  OptProperty({
    required super.propName,
  });

  void updateValueCascade({
    required Map<String, dynamic> currentValues,
    required Map<String, dynamic> updateValues,
  }) {
    if (!valueUpdated && dirty) {
      final dynamic oldValue = currentValues[propName];
      final dynamic newValue = updateValues[propName];
      //
      updateValue = newValue;
      valueUpdated = true;
    }
  }
}

class MasterProperty extends XProperty {
  late final MasterProperty? parent;
  final List<MasterProperty> children;
  XList? xList;

  MasterProperty({
    required super.propName,
    this.children = const [],
  });

  void _checkCycleError() {
    MasterProperty? p = parent;
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

  void updateValueCascase({
    required Map<String, dynamic> currentValues,
    required Map<String, dynamic> updateValues,
  }) {
    if (!valueUpdated && dirty) {
      final dynamic oldValue = currentValues[propName];
      final dynamic newValue = updateValues[propName];
      //
      updateValue = newValue;
      valueUpdated = true;
      //
      if (xList == null) {
        return;
      }
      bool isSame = xList!.isSame(item1: oldValue, item2: newValue);
      if (!isSame || newValue == null) {
        for (MasterProperty childItem in children) {
          if (childItem.xList != null) {
            childItem.xList!.clear();
            childItem.xList = null;
            updateValues[childItem.propName] = null;
            childItem.dirty = true;
          }
        }
      }
    }
    //
    for (MasterProperty childItem in children) {
      childItem.updateValueCascase(
        currentValues: currentValues,
        updateValues: updateValues,
      );
    }
  }
}
