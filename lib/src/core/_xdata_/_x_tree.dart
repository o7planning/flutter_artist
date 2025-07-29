part of '../_fa_core.dart';

class XTree<ID, TREE_ITEM, TREE_DATA> extends XData<ID, TREE_ITEM, TREE_DATA> {
  final TREE_DATA treeData;

  List<TREE_ITEM> Function() getRootTreeItems;
  List<TREE_ITEM>? Function(TREE_ITEM item) getChildren;
  void Function(TREE_ITEM item) addNotFoundTreeItem;
  void Function(TREE_ITEM item) removeNotFoundTreeItem;

  XTree({
    required this.treeData,
    required super.getItemId,
    required this.getRootTreeItems,
    required this.getChildren,
    required this.addNotFoundTreeItem,
    required this.removeNotFoundTreeItem,
  });

  @override
  TREE_DATA get data {
    return treeData;
  }

  TREE_ITEM? __findIdByIdCascade(List<TREE_ITEM> items, ID? id) {
    if (id == null) {
      return null;
    }
    for (TREE_ITEM item in items) {
      if (getItemId(item) == id) {
        return item;
      }
      List<TREE_ITEM>? children = getChildren(item);
      if (children != null) {
        TREE_ITEM? found = __findIdByIdCascade(children, id);
        if (found != null) {
          return found;
        }
      }
    }
    return null;
  }

  @override
  TREE_ITEM? findInternalItemByItemId(ID? id) {
    List<TREE_ITEM> rootItems = getRootTreeItems();
    return __findIdByIdCascade(rootItems, id);
  }

  @override
  void addNotFoundItem(TREE_ITEM item) {
    addNotFoundTreeItem(item);
  }

  @override
  void removeNotFoundItem(TREE_ITEM item) {
    removeNotFoundTreeItem(item);
  }
}
