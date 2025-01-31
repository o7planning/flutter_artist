part of '../flutter_artist.dart';

class FormUtils {
  static ITEM? findItemById<ITEM, ID>({
    required ID id,
    required List<ITEM> targetList,
    required ID Function(ITEM item) getItemId,
  }) {
    for (ITEM item in targetList) {
      if (getItemId(item) == id) {
        return item;
      }
    }
    return null;
  }

  // static void removeDuplicatedItemsFromList<ITEM, ID>({
  //   required List<ITEM> targetList,
  //   required ID Function(ITEM item) getItemId,
  // }) {
  //   List<ITEM> newList= [];
  //
  //   int idx = targetList.indexWhere((it) {
  //     return getItemId(it) == getItemId(removeItem);
  //   });
  //   if (idx != -1) {
  //     targetList.removeAt(idx);
  //   }
  // }

  static void removeItemFromList<ITEM, ID>({
    required ITEM removeItem,
    required List<ITEM> targetList,
    required ID Function(ITEM item) getItemId,
  }) {
    int idx = targetList.indexWhere((it) {
      return getItemId(it) == getItemId(removeItem);
    });
    if (idx != -1) {
      targetList.removeAt(idx);
    }
  }

  static void insertOrReplaceItemInList<ITEM, ID>({
    required ITEM item,
    required List<ITEM> targetList,
    required ID Function(ITEM item) getItemId,
  }) {
    int idx = targetList.indexWhere((it) {
      return getItemId(it) == getItemId(item);
    });
    if (idx == -1) {
      targetList.insert(0, item);
    } else {
      targetList[idx] = item;
    }
  }

  static void insertOrReplaceItemsInList<ITEM, ID>({
    required List<ITEM> items,
    required List<ITEM> targetList,
    required ID Function(ITEM item) getItemId,
  }) {
    for (ITEM item in items) {
      insertOrReplaceItemInList(
        item: item,
        targetList: targetList,
        getItemId: getItemId,
      );
    }
  }

  static void replaceItemInList<ITEM, ID>({
    required ITEM replacementItem,
    required List<ITEM> targetList,
    required ID Function(ITEM item) getItemId,
  }) {
    int idx = targetList.indexWhere((it) {
      return getItemId(it) == getItemId(replacementItem);
    });
    if (idx != -1) {
      targetList[idx] = replacementItem;
    }
  }

  static void replaceItemsInList<ITEM, ID>({
    required List<ITEM> replacementItems,
    required List<ITEM> targetList,
    required ID Function(ITEM item) getItemId,
  }) {
    for (ITEM replacementItem in replacementItems) {
      replaceItemInList(
        replacementItem: replacementItem,
        targetList: targetList,
        getItemId: getItemId,
      );
    }
  }

  static ITEM? findNextSiblingItemInList<ITEM, ID>({
    required List<ITEM> targetList,
    required ITEM item,
    required ID Function(ITEM item) getItemId,
  }) {
    int idx = targetList.indexWhere((e) {
      return getItemId(e) == getItemId(item);
    });
    if (idx == -1) {
      return null;
    } else {
      if (idx + 1 < targetList.length) {
        return targetList[idx + 1];
      }
      return null;
    }
  }

  static ITEM? findPreviousSiblingItemInList<ITEM, ID>({
    required List<ITEM> targetList,
    required ITEM item,
    required ID Function(ITEM item) getItemId,
  }) {
    int idx = targetList.indexWhere((e) {
      return getItemId(e) == getItemId(item);
    });
    if (idx == -1) {
      return null;
    } else {
      if (idx - 1 >= 0) {
        return targetList[idx - 1];
      }
      return null;
    }
  }

  static ITEM? findSiblingItemInList<ITEM, ID>({
    required List<ITEM> targetList,
    required ITEM item,
    required ID Function(ITEM item) getItemId,
  }) {
    int idx = targetList.indexWhere((e) {
      return getItemId(e) == getItemId(item);
    });
    if (idx == -1) {
      if (targetList.isNotEmpty) {
        return targetList[0];
      }
      return null;
    } else {
      if (idx + 1 < targetList.length) {
        return targetList[idx + 1];
      } else if (idx - 1 >= 0) {
        return targetList[idx - 1];
      }
      return null;
    }
  }

  ///
  /// Append items to targetList.
  ///
  static void appendItemsToList<ITEM, ID>({
    required List<ITEM> appendItems,
    required List<ITEM> targetList,
    required ID Function(ITEM item) getItemId,
  }) {
    List<ITEM> all = [];
    List<ITEM> tailItems = [...appendItems];
    for (ITEM item in targetList) {
      ITEM? it = _getItemBySameItemId(
        items: appendItems,
        sameItem: item,
        getItemId: getItemId,
      );
      if (it != null) {
        all.add(it);
        tailItems.remove(it);
      } else {
        all.add(item);
      }
    }
    all.addAll(tailItems);
    //
    targetList
      ..clear()
      ..addAll(all);
  }

  static bool isListContainItem<ITEM, ID>({
    required ITEM item,
    required List<ITEM> targetList,
    required ID Function(ITEM it) getItemId,
  }) {
    ID itemId = getItemId(item);
    return findItemById(
          id: itemId,
          targetList: targetList,
          getItemId: getItemId,
        ) !=
        null;
  }

  static bool isListContainItems<ITEM, ID>({
    required List<ITEM> items,
    required List<ITEM> targetList,
    required ID Function(ITEM it) getItemId,
  }) {
    for (ITEM item in items) {
      bool contains = isListContainItem(
        item: item,
        targetList: targetList,
        getItemId: getItemId,
      );
      if (!contains) {
        return false;
      }
    }
    return true;
  }
}
