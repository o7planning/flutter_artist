part of '../flutter_artist.dart';

class _Storage {
  // final _StorageChangeManager _changeManager = _StorageChangeManager();

  final List<Shelf> _rencentShelves = [];

  final Map<String, ShelfCreator> __shelfCreatorMap = {};
  final Map<String, Shelf> __shelfMap = {};

  void fireSourceChanged({
    required Block eventBlock,
    required String? itemIdString,
  }) {
    _notifyChange(eventBlock, itemIdString);
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
    // _changeManager._registerShelf(shelfName, shelf);
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

  // TODO: Xem lai
  bool _contains(List<Type> listenTypes, Type type) {
    for (Type t in listenTypes) {
      if (t == type) {
        return true;
      }
    }
    return false;
  }

  // Private Method. Only for use in this class.
  void __findNotifierShelfCascade({
    required Block listenerBlock,
    required Map<String, Shelf> foundShelfMap,
  }) {
    List<Type> listenTypes = listenerBlock.listenItemTypes;

    for (Shelf shelf in __shelfMap.values) {
      if (shelf == listenerBlock.shelf) {
        continue;
      }
      List<Block> allBlocks = shelf.blocks;
      for (Block blk in allBlocks) {
        if (!blk.fireEvent) {
          continue;
        }
        Type itemType = blk.getItemType();
        if (_contains(listenTypes, itemType)) {
          String shelfType = _getShelfName(shelf.runtimeType);
          foundShelfMap[shelfType] = shelf;
          continue;
        }
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
    if (block.listenItemTypes.isNotEmpty) {
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
  List<ShelfBlockType> _getListenerShelfBlockTypes(
      {required Block eventBlock}) {
    List<ShelfBlockType> foundShelfBlockTypes = [];

    for (String shelfName in __shelfMap.keys) {
      Shelf? shelf = __shelfMap[shelfName];
      if (shelf == null) {
        continue;
      }
      for (Block rootBlock in shelf.rootBlocks) {
        __findListenerShelfBlockTypesCascade(
          eventBlock: eventBlock,
          blockToCheck: rootBlock,
          foundShelfBlockTypes: foundShelfBlockTypes,
        );
      }
    }
    return foundShelfBlockTypes;
  }

  // Private Method. Only for use in this class.
  void __findListenerShelfBlockTypesCascade({
    required Block eventBlock,
    required Block blockToCheck,
    required List<ShelfBlockType> foundShelfBlockTypes,
  }) {
    if (!eventBlock.fireEvent) {
      return;
    }
    final Type itemType = eventBlock.getItemType();
    if (_contains(blockToCheck.listenItemTypes, itemType)) {
      foundShelfBlockTypes.add(
        ShelfBlockType(
          shelfType: blockToCheck.shelf.runtimeType,
          blockType: blockToCheck.runtimeType,
        ),
      );
    }
    for (Block childBlock in blockToCheck.childBlocks) {
      __findListenerShelfBlockTypesCascade(
        eventBlock: eventBlock,
        blockToCheck: childBlock,
        foundShelfBlockTypes: foundShelfBlockTypes,
      );
    }
  }

  // Callable.
  List<ShelfBlockType> _getEventShelfBlockTypes({
    required Block listenerBlock,
  }) {
    List<ShelfBlockType> foundShelfBlockTypes = [];

    for (Shelf shelf in __shelfMap.values) {
      List<Block> allBlocks = shelf.blocks;
      for (Block blk in allBlocks) {
        if (!blk.fireEvent) {
          continue;
        }
        if (_contains(listenerBlock.listenItemTypes, blk.getItemType())) {
          foundShelfBlockTypes.add(
            ShelfBlockType(
              shelfType: shelf.runtimeType,
              blockType: blk.runtimeType,
            ),
          );
        }
      }
    }
    return foundShelfBlockTypes;
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

  // ===========================================================================
  // ===========================================================================

  // ===========================================================================
  // ===========================================================================

  // ===========================================================================
  // ===========================================================================

  // ===========================================================================
  // ===========================================================================

  // ===========================================================================
  // ===========================================================================

  // ===========================================================================
  // ===========================================================================

  // ===========================================================================
  // ===========================================================================

  // Map<SourceOfChange, List<Block>> _getNotifierAndListenerMap() {
  //   Map<SourceOfChange, List<Block>> returnMap = {};
  //   for (Shelf shelf in _registedShelfMap.values) {
  //     for (Block block in shelf.rootBlocks) {
  //       __registerListenerBlockCascade(block, returnMap);
  //     }
  //   }
  //   return returnMap;
  // }
  //
  // void __registerListenerBlockCascade(
  //   Block listenerBlock,
  //   Map<SourceOfChange, List<Block>> returnMap,
  // ) {
  //   List<SourceOfChange>? sources = listenerBlock.listenForChangesFrom;
  //   for (SourceOfChange source in sources ?? []) {
  //     List<Block>? list = returnMap[source];
  //     if (list == null) {
  //       list = [];
  //       returnMap[source] = list;
  //     }
  //     list.add(listenerBlock);
  //   }
  //   for (Block childBlock in listenerBlock._childBlocks) {
  //     __registerListenerBlockCascade(childBlock, returnMap);
  //   }
  // }

  // ===========================================================================
  // ===========================================================================

  // List<ShelfBlockType> getChangeListeners({required Block eventBlock}) {
  //
  //   Type eventItemType = eventBlock.getItemType();
  //
  //   for(Shelf listenShelf in _registedShelfMap.values) {
  //     if(listenShelf == eventBlock.shelf) {
  //       continue;
  //     }
  //     for(Block listenBlk in listenShelf.blocks) {
  //      //if( listenBlk.listenItemTypes)
  //     }
  //
  //   }
  //   SourceOfChange source = _blockToSourceOfChange(eventBlock);
  //
  //   List<Block> listenerBlocks = _getNotifierAndListenerMap()[source] ?? [];
  //   return listenerBlocks
  //       .map(
  //         (b) => ShelfBlockType(
  //           shelfType: b.shelf.runtimeType,
  //           blockType: b.runtimeType,
  //         ),
  //       )
  //       .toList();
  // }

  // SourceOfChange _blockToSourceOfChange(Block sourceBlock) {
  //   Type shelfType = sourceBlock.shelf.runtimeType;
  //   Type blockType = sourceBlock.runtimeType;
  //   SourceOfChange source = SourceOfChange(
  //     shelfType: shelfType,
  //     blockType: blockType,
  //   );
  //   return source;
  // }

  // List<Block> _getListenerBlocks(Block eventBlock)  {
  //   List<Block> foundListenerBlocks = [];
  //
  //   for (String shelfName in __shelfMap.keys) {
  //     Shelf? shelf = __shelfMap[shelfName];
  //     if (shelf == null) {
  //       continue;
  //     }
  //     for (Block rootBlock in shelf.rootBlocks) {
  //       __findListenerShelfBlockTypesCascade(
  //         eventBlock: eventBlock,
  //         blockToCheck: rootBlock,
  //         foundListenerBlocks: foundListenerBlocks,
  //       );
  //     }
  //   }
  //   return foundListenerBlocks;
  // }

  void _notifyChange(Block eventBlock, String? itemIdString) {
    Type eventItemType = eventBlock.getItemType();
    print("~~~~~~~~~> Event Item Type: $eventItemType");
    //
    List<ShelfBlockType> listeners =
        _getListenerShelfBlockTypes(eventBlock: eventBlock);

    // SourceOfChange source = _blockToSourceOfChange(eventBlock);
    // print("~~~~~~~~~> SourceOfChange: ${source}");

    List<Block> listenerBlocks = _getListenerBlocks(eventBlock: eventBlock);
    for (Block listenerBlock in listenerBlocks) {
      if (!listenerBlock.hasActiveBlockFragmentWidget(
        alsoCheckChildren: true,
      )) {
        listenerBlock.data.setToPending();
      }
    }
    List<Block> queryBlocks = [];
    for (Block listenerBlock in listenerBlocks) {
      if (listenerBlock.hasActiveBlockFragmentWidget(
        alsoCheckChildren: true,
      )) {
        queryBlocks.add(listenerBlock);
      }
    }
    //
    if (queryBlocks.isNotEmpty) {
      // TODO: Neu co 2 Flu thi sao??
      queryBlocks.first.shelf._queryBlocks(
        queryType: QueryType.forceQuery,
        blocks: queryBlocks,
      );
    }
  }

  // Callable.
  List<Block> _getListenerBlocks({required Block eventBlock}) {
    List<Block> foundListenerBlocks = [];

    for (String shelfName in __shelfMap.keys) {
      Shelf? shelf = __shelfMap[shelfName];
      if (shelf == null) {
        continue;
      }
      for (Block rootBlock in shelf.rootBlocks) {
        __findListenerBlocksCascade(
          eventBlock: eventBlock,
          blockToCheck: rootBlock,
          foundListenerBlocks: foundListenerBlocks,
        );
      }
    }
    return foundListenerBlocks;
  }

  // Private Method. Only for use in this class.
  void __findListenerBlocksCascade({
    required Block eventBlock,
    required Block blockToCheck,
    required List<Block> foundListenerBlocks,
  }) {
    if (!eventBlock.fireEvent) {
      return;
    }
    final Type itemType = eventBlock.getItemType();
    if (_contains(blockToCheck.listenItemTypes, itemType)) {
      foundListenerBlocks.add(blockToCheck);
    }
    for (Block childBlock in blockToCheck.childBlocks) {
      __findListenerBlocksCascade(
        eventBlock: eventBlock,
        blockToCheck: childBlock,
        foundListenerBlocks: foundListenerBlocks,
      );
    }
  }
}
