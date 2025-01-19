part of '../flutter_artist.dart';

class _Storage {
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
    final String shelfName = _getShelfName(F);
    ShelfCreator? creator = __shelfCreatorMap[shelfName];
    if (creator == null) {
      __shelfCreatorMap[shelfName] = builder;
    }
    _createShelf(shelfName);
  }

  F _createShelf<F extends Shelf>(String shelfName) {
    F? shelf = __shelfMap[shelfName] as F?;
    if (shelf != null) {
      return shelf;
    }
    print("FLUTTER ARTIST DEBUG >>>>>>>>>>>>>>> create Shelf: $shelfName");

    ShelfCreator? creator = __shelfCreatorMap[shelfName];
    if (creator == null) {
      throw _registerError(
          " ERROR: '$shelfName' not found. You need to call:\n "
          " FlutterArtist.storage.registerShelf(()=> $shelfName())");
    }
    shelf = creator() as F;
    __shelfMap[shelfName] = shelf;
    //
    return shelf;
  }

  void _loadAll() {
    for (String shelfName in __shelfCreatorMap.keys) {
      _createShelf(shelfName);
    }
  }

  Shelf? _findShelf(Type shelfType) {
    final String shelfName = _getShelfName(shelfType);
    Shelf? shelf = __shelfMap[shelfName];
    shelf ??= _createShelf(shelfName);
    return shelf;
  }

  F findShelf<F extends Shelf>() {
    final String shelfName = _getShelfName(F);
    Shelf? shelf = __shelfMap[shelfName];
    shelf ??= _createShelf(shelfName);
    return shelf as F;
  }

  F? findOrNullShelf<F extends Shelf>() {
    final String shelfName = _getShelfName(F);
    F? shelf = __shelfMap[shelfName] as F?;
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
    // Name, Shelf
    Map<String, Shelf> foundEventShelfMap = {};
    //
    for (Shelf shelf in __shelfMap.values) {
      List<Block> listenerBlocks = _getListenerBlocksByShelf(eventShelf: shelf);
      if (listenerBlocks.isNotEmpty) {
        foundEventShelfMap[shelf.name] = shelf;
        continue;
      }
      List<Scalar> listenerScalars =
          _getListenerScalarsByShelf(eventShelf: shelf);
      if (listenerScalars.isNotEmpty) {
        foundEventShelfMap[shelf.name] = shelf;
        continue;
      }
    }
    return foundEventShelfMap;
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
    // Name, Shelf
    Map<String, Shelf> foundShelfMap = {};
    //
    for (String shelfName in __shelfMap.keys) {
      Shelf listenerShelf = __shelfMap[shelfName]!;

      List<Block> eventBlocks =
          _getEventBlocksByShelf(listenerShelf: listenerShelf);
      if (eventBlocks.isNotEmpty) {
        foundShelfMap[shelfName] = listenerShelf;
        continue;
      }
    }
    return foundShelfMap;
  }

  // ===========================================================================
  // ===========================================================================

  List<Block> _getEventBlocksByShelf({required Shelf listenerShelf}) {
    // FullName, Block
    Map<String, Block> foundMap = {};
    //
    for (Block listenerBlock in listenerShelf.blocks) {
      List<Block> eventBlocks = _getEventBlocksByBlock(
        listenerBlock: listenerBlock,
      );
      for (var eb in eventBlocks) {
        foundMap[eb._shortPathName] = eb;
      }
    }
    for (Scalar listenerScalar in listenerShelf.scalars) {
      List<Block> eventBlocks = _getEventBlocksByScalar(
        listenerScalar: listenerScalar,
      );
      for (var eb in eventBlocks) {
        foundMap[eb._shortPathName] = eb;
      }
    }
    return foundMap.values.toList();
  }

  List<Block> _getListenerBlocksByShelf({required Shelf eventShelf}) {
    // FullName, Block
    Map<String, Block> foundMap = {};
    //
    for (Block eventBlock in eventShelf.blocks) {
      List<Block> listenerBlocks = _getListenerBlocksByBlock(
        eventBlock: eventBlock,
      );
      for (var lb in listenerBlocks) {
        foundMap[lb._shortPathName] = lb;
      }
    }
    return foundMap.values.toList();
  }

  List<Scalar> _getListenerScalarsByShelf({required Shelf eventShelf}) {
    // FullName, Scalar
    Map<String, Scalar> foundMap = {};
    //
    for (Block eventBlock in eventShelf.blocks) {
      List<Scalar> listenerScalars = _getListenerScalarsByBlock(
        eventBlock: eventBlock,
      );
      for (var scalar in listenerScalars) {
        foundMap[scalar._shortPathName] = scalar;
      }
    }
    return foundMap.values.toList();
  }

  // Callable.
  List<Block> _getListenerBlocksByBlock({required Block eventBlock}) {
    if (!eventBlock.fireEvent) {
      return [];
    }
    // FullName, Block
    Map<String, Block> foundMap = {};

    for (String shelfName in __shelfMap.keys) {
      Shelf? shelf = __shelfMap[shelfName];
      if (shelf == null) {
        continue;
      }
      for (Block blockToCheck in shelf.blocks) {
        final Type eventItemType = eventBlock.getItemType();
        if (_contains(blockToCheck.listenItemTypes, eventItemType)) {
          foundMap[blockToCheck._shortPathName] = blockToCheck;
        }
      }
    }
    return foundMap.values.toList();
  }

  List<Scalar> _getListenerScalarsByBlock({required Block eventBlock}) {
    if (!eventBlock.fireEvent) {
      return [];
    }
    // FullName, Scalar
    Map<String, Scalar> foundMap = {};

    for (String shelfName in __shelfMap.keys) {
      Shelf? shelf = __shelfMap[shelfName];
      if (shelf == null) {
        continue;
      }
      for (Scalar scalar in shelf.scalars) {
        if (_contains(scalar.listenItemTypes, eventBlock.getItemType())) {
          foundMap[scalar._shortPathName] = scalar;
        }
      }
    }
    return foundMap.values.toList();
  }

  // Callable.
  List<ShelfBlockScalarType> _getListenerShelfBlockScalarTypes({
    required _BlockOrScalar eventBlockOrScalar,
  }) {
    if (eventBlockOrScalar.block != null) {
      List<Block> listenerBlocks = _getListenerBlocksByBlock(
        eventBlock: eventBlockOrScalar.block!,
      );
      List<Scalar> listenerScalars = _getListenerScalarsByBlock(
        eventBlock: eventBlockOrScalar.block!,
      );
      //
      List<ShelfBlockScalarType> foundShelfBlockTypes = [];
      for (Block listenerBlock in listenerBlocks) {
        foundShelfBlockTypes.add(
          ShelfBlockScalarType.block(
            shelfType: listenerBlock.shelf.runtimeType,
            blockType: listenerBlock.runtimeType,
            blockClassDefinition: listenerBlock._classDefinition,
          ),
        );
      }
      for (Scalar listenerScalar in listenerScalars) {
        foundShelfBlockTypes.add(
          ShelfBlockScalarType.scalar(
            shelfType: listenerScalar.shelf.runtimeType,
            scalarType: listenerScalar.runtimeType,
            scalarClassDefinition: listenerScalar._classDefinition,
          ),
        );
      }
      return foundShelfBlockTypes;
    } else {
      return [];
    }
  }

  // Callable.
  List<Block> _getEventBlocksByBlock({
    required Block listenerBlock,
  }) {
    // FullName, Block
    Map<String, Block> foundMap = {};

    for (Shelf shelf in __shelfMap.values) {
      List<Block> allBlocks = shelf.blocks;
      for (Block blk in allBlocks) {
        if (!blk.fireEvent) {
          continue;
        }
        if (_contains(listenerBlock.listenItemTypes, blk.getItemType())) {
          foundMap[blk._shortPathName] = blk;
        }
      }
    }
    return foundMap.values.toList();
  }

  // Callable.
  List<Block> _getEventBlocksByScalar({
    required Scalar listenerScalar,
  }) {
    // FullName, Block
    Map<String, Block> foundMap = {};

    for (Shelf shelf in __shelfMap.values) {
      for (Block blk in shelf.blocks) {
        if (!blk.fireEvent) {
          continue;
        }
        if (_contains(listenerScalar.listenItemTypes, blk.getItemType())) {
          foundMap[blk._shortPathName] = blk;
        }
      }
    }
    return foundMap.values.toList();
  }

  // Callable.
  List<ShelfBlockScalarType> _getEventShelfBlockTypes({
    required _BlockOrScalar listenerBlockOrScalar,
  }) {
    final List<Block> foundEventBlocks;
    if (listenerBlockOrScalar.block != null) {
      foundEventBlocks = _getEventBlocksByBlock(
        listenerBlock: listenerBlockOrScalar.block!,
      );
    } else {
      foundEventBlocks = _getEventBlocksByScalar(
        listenerScalar: listenerBlockOrScalar.scalar!,
      );
    }

    List<ShelfBlockScalarType> foundEventShelfBlockTypes = [];
    for (Block eventBlock in foundEventBlocks) {
      foundEventShelfBlockTypes.add(
        ShelfBlockScalarType.block(
          shelfType: eventBlock.shelf.runtimeType,
          blockType: eventBlock.runtimeType,
          blockClassDefinition: eventBlock._classDefinition,
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

  Future<void> _notifyChange(Block eventBlock, String? itemIdString) async {
    Type eventItemType = eventBlock.getItemType();
    print("~~~~~~~~~> Event Item Type: $eventItemType");
    //
    final List<Scalar> listenerScalars = _getListenerScalarsByBlock(
      eventBlock: eventBlock,
    );
    for (Scalar listenerScalar in listenerScalars) {
      if (!listenerScalar.hasActiveScalarFragmentWidget()) {
        listenerScalar.data.setToPending();
      }
    }
    // <String shelfName>
    Map<String, _ScalarAndBlockList> queryMap = {};

    for (Scalar listenerScalar in listenerScalars) {
      if (listenerScalar.hasActiveScalarFragmentWidget()) {
        String shelfName = listenerScalar.shelf.name;
        _ScalarAndBlockList sbList =
            queryMap[shelfName] ?? _ScalarAndBlockList();
        queryMap[shelfName] = sbList;
        sbList.queryScalars.add(listenerScalar);
      }
    }
    //
    final List<Block> listenerBlocks =
        _getListenerBlocksByBlock(eventBlock: eventBlock);
    for (Block listenerBlock in listenerBlocks) {
      // TODO: Doi thanh hasActiveUiComponents()??
      final bool active = listenerBlock.hasActiveBlockFragmentWidget(
        alsoCheckChildren: true,
      );
      if (!active) {
        listenerBlock.data.setToPending();
      }
    }

    for (Block listenerBlock in listenerBlocks) {
      // TODO: Doi thanh hasActiveUiComponents()??
      final bool active = listenerBlock.hasActiveBlockFragmentWidget(
        alsoCheckChildren: true,
      );
      if (active) {
        String shelfName = listenerBlock.shelf.name;
        _ScalarAndBlockList sbList =
            queryMap[shelfName] ?? _ScalarAndBlockList();
        queryMap[shelfName] = sbList;
        sbList.queryBlocks.add(listenerBlock);
      }
    }
    //
    for (String shelfName in queryMap.keys) {
      Shelf shelf = __shelfMap[shelfName]!;
      _ScalarAndBlockList sbList = queryMap[shelfName]!;
      //
      await shelf._queryAllWithOverlayAndRestorable(
        forceDataFilterOpt: null,
        forceQueryScalarOpts: sbList.queryScalars
            .map(
              (s) => _ScalarOpt(scalar: s),
            )
            .toList(),
        forceQueryBlockOpts: sbList.queryBlocks
            .map(
              (b) => _BlockOpt(
                  block: b,
                  queryType: null,
                  pageable: null,
                  listBehavior: null,
                  suggestedSelection: null,
                  postQueryBehavior: null),
            )
            .toList(),
        forceQueryBlockFormOpts: [],
      );
    }
  }

  // ===========================================================================
  // ===========================================================================

  void _logout() {
    __shelfMap.clear();
  }
}
