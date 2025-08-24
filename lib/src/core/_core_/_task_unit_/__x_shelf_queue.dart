part of '../core.dart';

class _XShelfQueue {
  //
  // LinkedHashMap<String, XShelf>().
  //
  final __xShelfMapQueue = <String, XShelf>{};

  bool get isEmpty {
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
