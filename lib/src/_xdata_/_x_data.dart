part of '../../flutter_artist.dart';

abstract class XData<ID, ITEM, DATA> {
  final ID Function(ITEM item) _getItemId;

  // final List<ITEM> _notFoundItems = [];

  final Map<ID, ITEM> _notFoundItemsMap = {};

  List<ITEM> get notFoundItems => [..._notFoundItemsMap.values];

  XData({
    required ID Function(ITEM item) getItemId,
  }) : _getItemId = getItemId;

  DATA get data;

  Type get itemType => ITEM;

  Type get itemIdType => ID;

  ITEM? findInternalItemByItemId(ID? id);

  void addNotFoundItem(ITEM item);

  void removeNotFoundItem(ITEM item);

  void __removeAllNotFoundItems() {
    for (ITEM item in _notFoundItemsMap.values) {
      removeNotFoundItem(item);
    }
  }

  ID getItemId(ITEM item) {
    return _getItemId(item);
  }

  bool contains({required ITEM? item}) {
    return findInternalItem(item: item) != null;
  }

  List<ITEM> _findInternalItemsByDynamics({
    required List<dynamic>? dynamicValues,
    required bool removeCurrentNotFoundItems,
    required bool addToInternalIfNotFound,
  }) {
    if (dynamicValues == null) {
      return [];
    }
    if (removeCurrentNotFoundItems) {
      __removeAllNotFoundItems();
    }
    //
    List<ITEM> items = dynamicValues
        .where((item) => item != null && item is ITEM)
        .cast<ITEM>()
        .toList();
    //
    return _findInternalItems(
      items: items,
      addToInternalIfNotFound: addToInternalIfNotFound,
    );
  }

  void _addInitialValueIfNotFound({
    required dynamic initialValue,
    required bool removeCurrentNotFoundItems,
  }) {
    if (removeCurrentNotFoundItems) {
      __removeAllNotFoundItems();
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
      addToInternalIfNotFound: true,
    );
  }

  List<ITEM> _findInternalItems({
    required List<ITEM?>? items,
    required bool addToInternalIfNotFound,
  }) {
    List<ITEM> ret = [];
    for (ITEM? item in items ?? []) {
      ITEM? found = _findInternalItem(
        item: item,
        addToInternalIfNotFound: addToInternalIfNotFound,
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
      addToInternalIfNotFound: false,
    );
  }

  ITEM? _findInternalItem({
    required ITEM? item,
    required bool addToInternalIfNotFound,
  }) {
    if (item == null) {
      return null;
    }
    ID id = getItemId(item);
    ITEM? found = findInternalItemByItemId(id);
    if (found == null) {
      if (addToInternalIfNotFound) {
        __addNotFoundItem(item);
        addNotFoundItem(item);
        return item;
      }
    }
    return found;
  }

  void __addNotFoundItem(ITEM item) {
    bool found = false;
    ID id = getItemId(item);
    _notFoundItemsMap[id] = item;
  }

  ITEM? findInternalItem({required ITEM? item}) {
    return _findInternalItem(
      item: item,
      addToInternalIfNotFound: false,
    );
  }

  List<ITEM> findInternalItemsByItemIds({required List<ID?>? itemIds}) {
    return itemIds!
        .map((id) => findInternalItemByItemId(id))
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
