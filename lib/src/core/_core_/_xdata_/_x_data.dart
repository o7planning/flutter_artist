part of '../core.dart';

abstract class XData<ID, ITEM, DATA> {
  final ID Function(ITEM item) _getItemId;

  final Map<ID, ITEM> _orphanItemsMap = {};

  List<ITEM> get orphanItems => List.unmodifiable(_orphanItemsMap.values);

  XData({
    required ID Function(ITEM item) getItemId,
  }) : _getItemId = getItemId;

  DATA get data;

  Type get itemType => ITEM;

  Type get itemIdType => ID;

  ITEM? findInternalItemById(ID? id);

  void addOrphanItem(ITEM item);

  void removeOrphanItem(ITEM item);

  void _clearOrphanItems() {
    for (ITEM item in _orphanItemsMap.values) {
      removeOrphanItem(item);
    }
  }

  ID getItemId(ITEM item) {
    return _getItemId(item);
  }

  bool contains({required ITEM? item}) {
    return findInternalItem(item: item) != null;
  }

  List<ITEM> _resolveItemsFromRawData({
    required List<dynamic>? dynamicValues,
    required bool clearOrphanItems,
    required bool addOrphan,
  }) {
    if (dynamicValues == null) {
      return [];
    }
    if (clearOrphanItems) {
      _clearOrphanItems();
    }
    //
    List<ITEM> items = dynamicValues
        .where((item) => item != null && item is ITEM)
        .cast<ITEM>()
        .toList();
    //
    return _findInternalItems(
      items: items,
      addOrphan: addOrphan,
    );
  }

  void _addInitialValueIfOrphan({
    required dynamic initialValue,
    required bool removeCurrentOrphanItems,
  }) {
    if (removeCurrentOrphanItems) {
      _clearOrphanItems();
    }
    if (initialValue == null) {
      return;
    }
    List<dynamic> dynamicValues;
    if (initialValue is List) {
      dynamicValues = [...initialValue];
    } else {
      dynamicValues = [initialValue];
    }
    List<ITEM> items = dynamicValues
        .where((item) => item != null && item is ITEM)
        .cast<ITEM>()
        .toList();
    //
    _findInternalItems(
      items: items,
      addOrphan: true,
    );
  }

  List<ITEM> _findInternalItems({
    required List<ITEM?>? items,
    required bool addOrphan,
  }) {
    List<ITEM> ret = [];
    for (ITEM? item in items ?? []) {
      ITEM? found = _findInternalItem(
        item: item,
        addOrphan: addOrphan,
      );
      if (found != null) {
        ret.add(found);
      }
    }
    return ret;
  }

  List<ITEM> findInternalItems({required List<ITEM?>? items}) {
    return _findInternalItems(
      items: items,
      addOrphan: false,
    );
  }

  ITEM? _findInternalItem({
    required ITEM? item,
    required bool addOrphan,
  }) {
    if (item == null) {
      return null;
    }
    ID id = getItemId(item);
    ITEM? found = findInternalItemById(id);
    if (found == null) {
      if (addOrphan) {
        __addOrphanItem(item);
        addOrphanItem(item);
        return item;
      }
    }
    return found;
  }

  void __addOrphanItem(ITEM item) {
    bool found = false;
    ID id = getItemId(item);
    _orphanItemsMap[id] = item;
  }

  ITEM? findInternalItem({required ITEM? item}) {
    return _findInternalItem(
      item: item,
      addOrphan: false,
    );
  }

  List<ITEM> findInternalItemsByIds({required List<ID?>? itemIds}) {
    return itemIds!
        .map((id) => findInternalItemById(id))
        .where((item) => item != null)
        .toList()
        .cast<ITEM>();
  }

  bool isSameItems({
    required List<ITEM> itemList1,
    required List<ITEM> itemList2,
  }) {
    for (ITEM it1 in itemList1) {
      if (!ItemsUtils.isListContainItem(
          item: it1, targetList: itemList2, getItemId: getItemId)) {
        return false;
      }
    }
    for (ITEM it2 in itemList2) {
      if (!ItemsUtils.isListContainItem(
          item: it2, targetList: itemList1, getItemId: getItemId)) {
        return false;
      }
    }
    return true;
  }

  bool isSame({
    required ITEM? item1,
    required ITEM? item2,
  }) {
    return ItemsUtils.isSame(
      item1: item1,
      item2: item2,
      getItemId: getItemId,
    );
  }

  bool isSameItemOrItemList({
    required dynamic itemOrItemList1,
    required dynamic itemOrItemList2,
  }) {
    if (itemOrItemList1 == null && itemOrItemList2 == null) {
      return true;
    } else if (itemOrItemList1 != null && itemOrItemList2 == null) {
      return false;
    } else if (itemOrItemList1 == null && itemOrItemList2 != null) {
      return false;
    }
    if (itemOrItemList1 is ITEM) {
      if (itemOrItemList2 is! ITEM) {
        return false;
      }
      return isSame(
        item1: itemOrItemList1,
        item2: itemOrItemList2,
      );
    } else if (itemOrItemList1 is List<ITEM>) {
      if (itemOrItemList2 is! List<ITEM>) {
        return false;
      }
      return isSameItems(
        itemList1: itemOrItemList1,
        itemList2: itemOrItemList2,
      );
    } else {
      return false;
    }
  }
}
