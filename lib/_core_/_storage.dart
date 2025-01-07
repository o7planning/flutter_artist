part of '../flutter_artist.dart';

class _Storage {
  final _StorageChangeManager _changeManager = _StorageChangeManager();

  final List<Shelf> _rencentShelves = [];

  final Map<String, ShelfCreator> __shelfCreatorMap = {};
  final Map<String, Shelf> __shelfMap = {};

  void fireSourceChanged({
    required Block sourceBlock,
    required String? itemIdString,
  }) {
    _changeManager._notifyChange(sourceBlock, itemIdString);
  }

  Map<String, Shelf?> get shelfMap {
    Map<String, Shelf?> m = __shelfCreatorMap
        .map((k, v) => MapEntry<String, Shelf?>(k, null))
      ..addAll(__shelfMap);
    return m;
  }

  String _getShelfName(Type type) {
    return type.toString();
  }

  void registerShelf<F extends Shelf>(ShelfCreator<F> builder) {
    final String key = _getShelfName(F);
    ShelfCreator? mng = __shelfCreatorMap[key];
    if (mng == null) {
      __shelfCreatorMap[key] = builder;
    }
  }

  F _createShelf<F extends Shelf>(String shelfName) {
    F? shelf = __shelfMap[shelfName] as F?;
    if (shelf != null) {
      return shelf;
    }
    print("FLUTTER ARTIST DEBUG >>>>>>>>>>>>>>> create Shelf: $shelfName");

    ShelfCreator? creator = __shelfCreatorMap[shelfName];
    if (creator == null) {
      throw "\n**********************************************************************************************************"
          "\n '${F.toString()}' not found. You need to call Storage.lazyPut(()=> $shelfName())"
          "\n**********************************************************************************************************";
    }
    shelf = creator() as F;
    __shelfMap[shelfName] = shelf;
    _changeManager._registerShelf(shelfName, shelf);
    return shelf;
  }

  void _loadAll() {
    for (String shelfName in __shelfCreatorMap.keys) {
      _createShelf(shelfName);
    }
  }

  Shelf? _findShelf(Type shelfType) {
    final String key = _getShelfName(shelfType);
    Shelf? shelf = __shelfMap[key];
    shelf ??= _createShelf(key);
    return shelf;
  }

  F findShelf<F extends Shelf>() {
    final String key = _getShelfName(F);
    Shelf? shelf = __shelfMap[key];
    shelf ??= _createShelf(key);
    return shelf as F;
  }

  F? findOrNullShelf<F extends Shelf>() {
    final String key = _getShelfName(F);
    F? shelf = __shelfMap[key] as F?;
    return shelf;
  }

  // ===========================================================================
  // ===========================================================================

  // @Callable
  Map<String, Shelf> _getIndependentShelves() {
    Map<String, Shelf> notifierMap = _getNotifierShelves();
    Map<String, Shelf> listenerMap = _getListenerShelves();
    Map<String, Shelf> map = {}..addAll(__shelfMap);
    map.removeWhere((shelfName, shelf) =>
        notifierMap.keys.contains(shelfName) ||
        listenerMap.keys.contains(shelfName));
    return map;
  }

  // @Callable
  Map<String, Shelf> _getNotifierShelves() {
    Map<String, Shelf> foundShelfMap = {};
    //
    for (Shelf shelf in __shelfMap.values) {
      __findNotifierShelves(
        listenerShelf: shelf,
        foundShelfMap: foundShelfMap,
      );
    }
    return foundShelfMap;
  }

  // Private Method. Only for use in this class.
  void __findNotifierShelves({
    required Shelf listenerShelf,
    required Map<String, Shelf> foundShelfMap,
  }) {
    for (Block rootListenerBlock in listenerShelf.rootBlocks) {
      __findNotifierShelfCascade(
        listenerBlock: rootListenerBlock,
        foundShelfMap: foundShelfMap,
      );
    }
  }

  // Private Method. Only for use in this class.
  void __findNotifierShelfCascade({
    required Block listenerBlock,
    required Map<String, Shelf> foundShelfMap,
  }) {
    for (SourceOfChange notifier in listenerBlock.listenForChangesFrom ?? []) {
      Type notifierShelfType = notifier.shelfType;
      String shelfName = _getShelfName(notifierShelfType);
      Shelf? notifierShelf = __shelfMap[shelfName];
      if (notifierShelf != null) {
        foundShelfMap[shelfName] = notifierShelf;
      }
    }
    for (Block childListenerBlock in listenerBlock.childBlocks) {
      __findNotifierShelfCascade(
        listenerBlock: childListenerBlock,
        foundShelfMap: foundShelfMap,
      );
    }
  }

// ===========================================================================
// ===========================================================================

  // @Callable
  Map<String, Shelf> _getListenerShelves() {
    Map<String, Shelf> foundShelfMap = {};
    //
    for (String shelfName in __shelfMap.keys) {
      Shelf shelf = __shelfMap[shelfName]!;

      for (Block rootBlock in shelf.rootBlocks) {
        bool found = __foundListenerShelfCascade(block: rootBlock);
        if (found) {
          foundShelfMap[shelfName] = shelf;
          break;
        }
      }
    }
    return foundShelfMap;
  }

  // Private Method. Only for use in this class.
  bool __foundListenerShelfCascade({required Block block}) {
    if (block.listenForChangesFrom != null &&
        block.listenForChangesFrom!.isNotEmpty) {
      return true;
    }
    for (Block childBlock in block.childBlocks) {
      bool found = __foundListenerShelfCascade(block: childBlock);
      if (found) {
        return true;
      }
    }
    return false;
  }

// ===========================================================================
// ===========================================================================

  // Callable.
  List<ShelfBlockType> _getListenerBlocks({required Block notifierBlock}) {
    List<ShelfBlockType> foundFluBlockTypes = [];

    for (String shelfName in __shelfMap.keys) {
      Shelf? shelf = __shelfMap[shelfName];
      if (shelf == null) {
        continue;
      }
      for (Block rootBlock in shelf.rootBlocks) {
        __findListenerBlocksCascade(
          notifierBlock: notifierBlock,
          blockToCheck: rootBlock,
          foundFluBlockTypes: foundFluBlockTypes,
        );
      }
    }
    return foundFluBlockTypes;
  }

  // Private Method. Only for use in this class.
  void __findListenerBlocksCascade({
    required Block notifierBlock,
    required Block blockToCheck,
    required List<ShelfBlockType> foundFluBlockTypes,
  }) {
    for (SourceOfChange notifier in blockToCheck.listenForChangesFrom ?? []) {
      if (notifier.shelfType == notifierBlock.shelf.runtimeType &&
          notifier.blockType == notifierBlock.runtimeType) {
        foundFluBlockTypes.add(
          ShelfBlockType(
            shelfType: blockToCheck.shelf.runtimeType,
            blockType: blockToCheck.runtimeType,
          ),
        );
        break;
      }
    }
    for (Block childBlock in blockToCheck.childBlocks) {
      __findListenerBlocksCascade(
        notifierBlock: notifierBlock,
        blockToCheck: childBlock,
        foundFluBlockTypes: foundFluBlockTypes,
      );
    }
  }

  // Callable.
  List<ShelfBlockType> _getNotifierBlocks({
    required Block listenerBlock,
  }) {
    List<ShelfBlockType> foundFluBlockTypes = [];
    for (SourceOfChange notifier in listenerBlock.listenForChangesFrom ?? []) {
      foundFluBlockTypes.add(
        ShelfBlockType(
          shelfType: notifier.shelfType,
          blockType: notifier.blockType,
        ),
      );
    }
    return foundFluBlockTypes;
  }

  void _addRecentShelf(Shelf shelf) {
    if (_rencentShelves.isEmpty) {
      _rencentShelves.add(shelf);
    } else {
      if (_rencentShelves.first == shelf) {
        return;
      } else {
        int idx = _rencentShelves.indexOf(shelf);
        if (idx == -1) {
          _rencentShelves.insert(0, shelf);
        } else {
          var temp = _rencentShelves[0];
          _rencentShelves[0] = _rencentShelves[idx];
          _rencentShelves[idx] = temp;
        }
      }
    }
  }

  void _checkToRemoveShelf(Shelf shelf) {
    // TODO.
  }

  Shelf? _recentShelf() {
    return _rencentShelves.isEmpty ? null : _rencentShelves.first;
  }

  // ===========================================================================
  // ===========================================================================

  void _logout() {
    __shelfMap.clear();
  }
}
