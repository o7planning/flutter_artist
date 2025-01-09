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
    Map<String, Shelf> eventMap = _getEventShelves();
    Map<String, Shelf> listenerMap = _getListenerShelves();
    Map<String, Shelf> map = {}..addAll(__shelfMap);
    map.removeWhere((shelfName, shelf) =>
        eventMap.keys.contains(shelfName) ||
        listenerMap.keys.contains(shelfName));
    return map;
  }

  // @Callable
  Map<String, Shelf> _getEventShelves() {
    Map<String, Shelf> foundEventShelfMap = {};
    //
    for (Shelf shelf in __shelfMap.values) {
      __findEventShelves(
        listenerShelf: shelf,
        foundEventShelfMap: foundEventShelfMap,
      );
    }
    return foundEventShelfMap;
  }

  // Private Method. Only for use in this class.
  void __findEventShelves({
    required Shelf listenerShelf,
    required Map<String, Shelf> foundEventShelfMap,
  }) {
    for (Block rootListenerBlock in listenerShelf.rootBlocks) {
      __findEventShelfCascade(
        listenerBlock: rootListenerBlock,
        foundShelfMap: foundEventShelfMap,
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
  void __findEventShelfCascade({
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
      __findEventShelfCascade(
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

  List<Scalar> _getListenerScalars({required Block eventBlock}) {
    List<Scalar> foundListenerScalars = [];

    for (String shelfName in __shelfMap.keys) {
      Shelf? shelf = __shelfMap[shelfName];
      if (shelf == null) {
        continue;
      }
      for (Scalar scalar in shelf.scalars) {
        if (_contains(scalar.listenItemTypes, eventBlock.getItemType())) {
          foundListenerScalars.add(scalar);
        }
      }
    }
    return foundListenerScalars;
  }

  // Callable.
  List<ShelfBlockScalarType> _getListenerShelfBlockTypes({
    required _BlockOrScalar eventBlockOrScalar,
  }) {
    if (eventBlockOrScalar.block != null) {
      List<Block> listenerBlocks = _getListenerBlocks(
        eventBlock: eventBlockOrScalar.block!,
      );
      List<Scalar> listenerScalars = _getListenerScalars(
        eventBlock: eventBlockOrScalar.block!,
      );
      //
      List<ShelfBlockScalarType> foundShelfBlockTypes = [];
      for (Block listenerBlock in listenerBlocks) {
        foundShelfBlockTypes.add(
          ShelfBlockScalarType.block(
            shelfType: listenerBlock.shelf.runtimeType,
            blockType: listenerBlock.runtimeType,
          ),
        );
      }
      for (Scalar listenerScalar in listenerScalars) {
        foundShelfBlockTypes.add(
          ShelfBlockScalarType.scalar(
            shelfType: listenerScalar.shelf.runtimeType,
            scalarType: listenerScalar.runtimeType,
          ),
        );
      }
      return foundShelfBlockTypes;
    } else {
      return [];
    }
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
    final Type eventItemType = eventBlock.getItemType();
    if (_contains(blockToCheck.listenItemTypes, eventItemType)) {
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

  // Callable.
  List<Block> _getEventBlocksForListenerBlock({
    required Block listenerBlock,
  }) {
    List<Block> foundEventBlocks = [];

    for (Shelf shelf in __shelfMap.values) {
      List<Block> allBlocks = shelf.blocks;
      for (Block blk in allBlocks) {
        if (!blk.fireEvent) {
          continue;
        }
        if (_contains(listenerBlock.listenItemTypes, blk.getItemType())) {
          foundEventBlocks.add(blk);
        }
      }
    }
    return foundEventBlocks;
  }

  // Callable.
  List<Block> _getEventBlocksForListenerScalar({
    required Scalar listenerScalar,
  }) {
    List<Block> foundEventBlocks = [];

    for (Shelf shelf in __shelfMap.values) {
      List<Block> allBlocks = shelf.blocks;
      for (Block blk in allBlocks) {
        if (!blk.fireEvent) {
          continue;
        }
        if (_contains(listenerScalar.listenItemTypes, blk.getItemType())) {
          foundEventBlocks.add(blk);
        }
      }
    }
    return foundEventBlocks;
  }

  // Callable.
  List<ShelfBlockScalarType> _getEventShelfBlockTypes({
    required _BlockOrScalar listenerBlockOrScalar,
  }) {
    final List<Block> foundEventBlocks;
    if (listenerBlockOrScalar.block != null) {
      foundEventBlocks = _getEventBlocksForListenerBlock(
        listenerBlock: listenerBlockOrScalar.block!,
      );
    } else {
      foundEventBlocks = _getEventBlocksForListenerScalar(
        listenerScalar: listenerBlockOrScalar.scalar!,
      );
    }

    List<ShelfBlockScalarType> foundEventShelfBlockTypes = [];
    for (Block eventBlock in foundEventBlocks) {
      foundEventShelfBlockTypes.add(
        ShelfBlockScalarType.block(
          shelfType: eventBlock.shelf.runtimeType,
          blockType: eventBlock.runtimeType,
        ),
      );
    }
    return foundEventShelfBlockTypes;
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

  void _notifyChange(Block eventBlock, String? itemIdString) {
    Type eventItemType = eventBlock.getItemType();
    print("~~~~~~~~~> Event Item Type: $eventItemType");
    //
    final List<Scalar> listenerScalars = _getListenerScalars(
      eventBlock: eventBlock,
    );
    for (Scalar listenerScalar in listenerScalars) {
      if (!listenerScalar.hasActiveScalarFragmentWidget()) {
        listenerScalar.data.setToPending();
      }
    }
    final List<Scalar> queryScalars = [];
    for (Scalar listenerScalar in listenerScalars) {
      if (listenerScalar.hasActiveScalarFragmentWidget()) {
        queryScalars.add(listenerScalar);
      }
    }
    //
    if (queryScalars.isNotEmpty) {
      // TODO: Neu co 2 Shelf(s) thi sao??
      queryScalars.first.shelf._queryScalars(
        scalars: queryScalars,
      );
    }
    //
    final List<Block> listenerBlocks =
        _getListenerBlocks(eventBlock: eventBlock);
    for (Block listenerBlock in listenerBlocks) {
      if (!listenerBlock.hasActiveBlockFragmentWidget(
        alsoCheckChildren: true,
      )) {
        listenerBlock.data.setToPending();
      }
    }
    final List<Block> queryBlocks = [];
    for (Block listenerBlock in listenerBlocks) {
      if (listenerBlock.hasActiveBlockFragmentWidget(
        alsoCheckChildren: true,
      )) {
        queryBlocks.add(listenerBlock);
      }
    }
    //
    if (queryBlocks.isNotEmpty) {
      // TODO: Neu co 2 Shelf(s) thi sao??
      queryBlocks.first.shelf._queryBlocks(
        queryType: QueryType.forceQuery,
        blocks: queryBlocks,
      );
    }
  }

  // ===========================================================================
  // ===========================================================================

  void _logout() {
    __shelfMap.clear();
  }
}
