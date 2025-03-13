part of '../flutter_artist.dart';

class _PropTreeBuilder {
  final Map<String, FindXList> __xListMap = {};
  final Map<String, String> __childAndParentPropMap = {};

  //

  _PropTreeBuilder();

  void addConstraint({
    required String? parentProperty,
    required String property,
    required FindXList findXList,
  }) {
    __xListMap[property] = findXList;
    if (parentProperty != null) {
      __childAndParentPropMap[property] = parentProperty;
    }
  }

  _PropTree build() {
    final Map<String, _PropTreeItem> itemMap = __xListMap.map(
      (k, v) => MapEntry(
        k,
        _PropTreeItem(propName: k, findXList: v),
      ),
    );
    //
    for (String prop in __childAndParentPropMap.keys) {
      String parentProp = __childAndParentPropMap[prop]!;
      _PropTreeItem? child = itemMap[prop];
      _PropTreeItem? parent = itemMap[parentProp];
      if (child == null) {
        throw "No XList '$prop'";
      } else if (parent == null) {
        throw "No XList '$parentProp'";
      }
      child.parent = parent;
      parent.children.add(child);
    }
    //
    for (_PropTreeItem item in itemMap.values) {
      item._checkCycleError();
    }
    //
    return _PropTree._(itemMap: itemMap);
  }
}

class _PropTree {
  final Map<String, _PropTreeItem> _itemMap = {};
  final List<_PropTreeItem> rootItems = [];

  _PropTree._({
    required Map<String, _PropTreeItem> itemMap,
  }) {
    _itemMap.addAll(itemMap);
    rootItems.addAll(itemMap.values.where((item) => item.parent == null));
  }

  _PropTreeItem? getItemByProp(String prop) {
    return _itemMap[prop];
  }

  void updateValues({
    required Map<String, dynamic> currentValues,
    required Map<String, dynamic> updateValues,
  }) {
    for (_PropTreeItem item in _itemMap.values) {
      item.updateValue = null;
      item.valueUpdated = false;
      item.dirty = false;
    }
    //
    for (String prop in updateValues.keys) {
      _PropTreeItem? item = _itemMap[prop];
      if (item != null) {
        item.dirty = true;
      }
    }
    //
    for (_PropTreeItem rootItem in rootItems) {
      rootItem.updateValueCascase(
        currentValues: currentValues,
        updateValues: updateValues,
      );
    }
  }
}

class _PropTreeItem {
  final String propName;
  final FindXList? findXList;
  dynamic updateValue;
  bool valueUpdated = false;
  bool dirty = false;

  //
  _PropTreeItem? parent;
  final List<_PropTreeItem> children = [];

  _PropTreeItem({
    required this.propName,
    required this.findXList,
  });

  void _checkCycleError() {
    _PropTreeItem? p = parent;
    List<String> propNames = [propName];
    while (true) {
      if (p == null) {
        return;
      }
      if (propNames.contains(p.propName) ){
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
      p= p.parent;
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
      if (findXList == null) {
        return;
      }
      XList? xList = findXList!();
      if (xList == null) {
        return;
      }
      print(">>>>>>>> oldValue: $oldValue");
      print(">>>>>>>> newValue: $newValue");
      bool isSame = xList.isSame(item1: oldValue, item2: newValue);
      if (!isSame) {
        for (_PropTreeItem childItem in children) {
          FindXList? childFindXList = childItem.findXList;
          if (childFindXList != null) {
            XList? childXList = childFindXList();
            if (childXList != null) {
              childXList.valid = false;
              updateValues[childItem.propName] = null;
              childItem.dirty = true;
            }
          }
        }
      }
    }
    //
    for (_PropTreeItem childItem in children) {
      childItem.updateValueCascase(
        currentValues: currentValues,
        updateValues: updateValues,
      );
    }
  }
}
