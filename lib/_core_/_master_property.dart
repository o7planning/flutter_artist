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

  void addOptProperty(OptProperty property) {
    if (!_xPropMap.containsKey(property.propName)) {
      _xPropMap[property.propName] = property;
      rootXProperties.add(property);
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
}

class MasterProperty extends XProperty {
  late final MasterProperty? parent;
  final List<MasterProperty> children;

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
}
