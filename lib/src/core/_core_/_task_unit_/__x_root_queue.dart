part of '../core.dart';

class _XRootQueue {
  final XStorage _xStorage = XStorage();

  //
  // LinkedHashMap<String, XShelf>().
  //
  final __xShelfMapQueue = <String, XShelf>{};

  bool get isEmpty {
    if (_xStorage.isNotEmpty) {
      return false;
    }
    for (XShelf xShelf in __xShelfMapQueue.values) {
      if (!xShelf.isEmptyTask()) {
        return false;
      }
    }
    return true;
  }

  bool get isNotEmpty => !isEmpty;

  void clear() {
    // TODO: Remove.
  }

  bool hasNext() {
    return isNotEmpty;
  }

  _TaskUnit? getNextTaskUnit() {
    _TaskUnit? tu = _xStorage._getNextTaskUnit();
    if (tu != null) {
      return tu;
    }
    while (true) {
      String? firstShelfName = __xShelfMapQueue.keys.firstOrNull;
      if (firstShelfName == null) {
        return null;
      }
      XShelf firstXShelf = __xShelfMapQueue[firstShelfName]!;
      if (firstXShelf.isEmptyTask()) {
        __xShelfMapQueue.remove(firstShelfName);
        continue;
      }
      return firstXShelf._getNextTaskUnit()!;
    }
  }

  void _addStorageSilentActionTaskUnit(
    _StorageSilentActionTaskUnit storageSilentActionTaskUnit,
  ) {
    _xStorage._addStorageSilentActionTaskUnit(storageSilentActionTaskUnit);
  }

  void _addXShelf(XShelf xShelf) {
    __xShelfMapQueue[xShelf.shelf.name] = xShelf;
  }

  DebugXShelfQueue toDebugXShelfQueue() {
    return DebugXShelfQueue(
      debugTaskUnitQueue: __xShelfMapQueue.entries
          .map((entry) => entry.value.toDebugXShelfTaskUnitQueue())
          .toList(),
    );
  }

  @override
  String toString() {
    return "TaskUnitQueue: $__xShelfMapQueue";
  }
}
