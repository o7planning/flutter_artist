part of '../code.dart';

typedef ShelfCreator<S> = S Function();

class _Storage {
  final List<Shelf> _rencentShelves = [];

  final Map<String, ShelfCreator> __shelfCreatorMap = {};
  final Map<String, Shelf> __shelfMap = {};

  Map<String, Shelf?> get shelfMap {
    Map<String, Shelf?> m = __shelfCreatorMap
        .map((k, v) => MapEntry<String, Shelf?>(k, null))
      ..addAll(__shelfMap);
    return m;
  }

  // ***************************************************************************
  // ***************************************************************************

  _Storage();

  // ***************************************************************************
  // ***************************************************************************

  void _logout() {
    __shelfMap.clear();
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Very Dangerous!!! Only call on startup.
  ///
  void __clear() {
    _rencentShelves.clear();
    __shelfCreatorMap.clear();
    __shelfMap.clear();
  }

  // ***************************************************************************
  // ***************************************************************************

  void _resetForTestOnly() {
    __shelfMap.clear();
  }

  // ***************************************************************************
  // ***************************************************************************

  void _fireEventToAffectedItemTypes({
    required Shelf eventShelf,
    required List<Type> affectedItemTypes,
  }) {
    final bool external = true;

    if (external) {
      final List<Scalar> listenerScalars =
          __getListenerScalarsByAffectedItemTypes(
        eventShelf: eventShelf,
        affectedItemTypes: affectedItemTypes,
        external: external,
      );
      //
      final List<Block> listenerBlocks = __getListenerBlocksByAffectedItemTypes(
        eventShelf: eventShelf,
        affectedItemTypes: affectedItemTypes,
      );
      //
      __executeListeners(
        listenerScalars: listenerScalars,
        listenerBlocks: listenerBlocks,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _fireEventSourceChanged({
    required Block eventBlock,
    required String? itemIdString,
  }) {
    final BlockOutsideBroadcast? outsideBroadcast =
        eventBlock.config.outsideBroadcast;
    final BlockInternalBroadcast? internalBroadcast =
        eventBlock.config.internalBroadcast;

    // Broadcast Data Types:
    List<Type> outsideEventTypes =
        eventBlock._getBroadcastDataTypes(external: true);
    List<Type> internalEventTypes =
        eventBlock._getBroadcastDataTypes(external: false);
    //
    print(
        "~~~~~~~~~> ${outsideBroadcast != null ? 'FIRE EVENT TO OUTSIDE' : 'NOT FIRE EVENT TO OUTSIDE'}"
        " --> Event Item Types: $outsideEventTypes"
        " - ${getClassName(eventBlock)}");

    print(
        "~~~~~~~~~> ${internalBroadcast != null ? 'FIRE EVENT IN INTERNAL' : 'NOT FIRE EVENT IN INTERNAL'}"
        " --> Event Item Types: $internalEventTypes"
        " - ${getClassName(eventBlock)}");

    if (internalBroadcast != null) {
      final List<Scalar> listenerScalars = __getListenerScalarsByBlock(
        eventBlock: eventBlock,
        external: false,
      );
      //
      final List<Block> listenerBlocks = __getListenerBlocksByBlock(
        eventBlock: eventBlock,
        external: false,
      );
      print(
          "~~~~~~~~~> listenerBlocks: $listenerBlocks, listenerScalars: $listenerScalars");
      //
      // TODO: Add to QUEUE lazy.
      //
      if (listenerScalars.isNotEmpty || listenerBlocks.isNotEmpty) {
        __executeListeners(
          listenerScalars: listenerScalars,
          listenerBlocks: listenerBlocks,
        );
      }
    }
    //
    if (outsideBroadcast != null) {
      final List<Scalar> listenerScalars = __getListenerScalarsByBlock(
        eventBlock: eventBlock,
        external: true,
      );
      //
      final List<Block> listenerBlocks = __getListenerBlocksByBlock(
        eventBlock: eventBlock,
        external: true,
      );
      print(
          "~~~~~~~~~> listenerBlocks: $listenerBlocks, listenerScalars: $listenerScalars");
      //
      // TODO: Add to QUEUE lazy.
      //
      if (listenerScalars.isNotEmpty || listenerBlocks.isNotEmpty) {
        __executeListeners(
          listenerScalars: listenerScalars,
          listenerBlocks: listenerBlocks,
        );
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  String _getShelfName(Type type) {
    return type.toString();
  }

  String debugGetShelfName(Type type) {
    return _getShelfName(type);
  }

  // ***************************************************************************
  // ***************************************************************************

  void registerShelf<F extends Shelf>(ShelfCreator<F> builder) {
    final String shelfName = _getShelfName(F);
    ShelfCreator? creator = __shelfCreatorMap[shelfName];
    if (creator == null) {
      __shelfCreatorMap[shelfName] = builder;
    }
    _createShelf(shelfName);
  }

  // ***************************************************************************
  // ***************************************************************************

  F _createShelf<F extends Shelf>(String shelfName) {
    F? shelf = __shelfMap[shelfName] as F?;
    if (shelf != null) {
      return shelf;
    }
    print("FLUTTER ARTIST DEBUG >>>>>>>>>>>>>>> create Shelf: $shelfName");

    ShelfCreator? creator = __shelfCreatorMap[shelfName];
    if (creator == null) {
      throw _printFatalError(
          " ERROR: '$shelfName' not found. You need to call:\n "
          " FlutterArtist.storage.registerShelf(()=> $shelfName())");
    }
    shelf = creator() as F;
    __shelfMap[shelfName] = shelf;
    //
    return shelf;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _loadAll() {
    for (String shelfName in __shelfCreatorMap.keys) {
      _createShelf(shelfName);
    }
  }

  // TODO: Internal Use.
  void debugLoadAll() {
    _loadAll();
  }

  // TODO: Internal Use.
  F debugCreateShelf<F extends Shelf>(String shelfName) {
    return _createShelf(shelfName);
  }

  // ***************************************************************************
  // ***************************************************************************

  Shelf? _findShelf(Type shelfType) {
    final String shelfName = _getShelfName(shelfType);
    Shelf? shelf = __shelfMap[shelfName];
    shelf ??= _createShelf(shelfName);
    return shelf;
  }

  // TODO: Internal Use.
  Shelf? debugFindShelf(Type shelfType) {
    return _findShelf(shelfType);
  }

  // ***************************************************************************
  // ***************************************************************************

  F findShelf<F extends Shelf>() {
    final String shelfName = _getShelfName(F);
    Shelf? shelf = __shelfMap[shelfName];
    shelf ??= _createShelf(shelfName);
    return shelf as F;
  }

  // ***************************************************************************
  // ***************************************************************************

  F? findOrNullShelf<F extends Shelf>() {
    final String shelfName = _getShelfName(F);
    F? shelf = __shelfMap[shelfName] as F?;
    return shelf;
  }

  // ***************************************************************************
  // ***************************************************************************

  // @Callable
  Map<String, Shelf> _getIndependentShelves({required bool external}) {
    Map<String, Shelf> eventMap = _getEventShelves(external: external);
    Map<String, Shelf> listenerMap = _getListenerShelves();
    Map<String, Shelf> map = {}..addAll(__shelfMap);
    map.removeWhere((shelfName, shelf) =>
        eventMap.keys.contains(shelfName) ||
        listenerMap.keys.contains(shelfName));
    return map;
  }

  // ***************************************************************************
  // ***************************************************************************

  // @Callable
  Map<String, Shelf> _getEventShelves({required bool external}) {
    // Name, Shelf
    Map<String, Shelf> foundEventShelfMap = {};
    //
    for (Shelf shelf in __shelfMap.values) {
      List<Block> listenerBlocks = _getListenerBlocksByShelf(
        eventShelf: shelf,
        external: external,
      );
      if (listenerBlocks.isNotEmpty) {
        foundEventShelfMap[shelf.name] = shelf;
        continue;
      }
      List<Scalar> listenerScalars = _getListenerScalarsByShelf(
        eventShelf: shelf,
        external: external,
      );
      if (listenerScalars.isNotEmpty) {
        foundEventShelfMap[shelf.name] = shelf;
        continue;
      }
    }
    return foundEventShelfMap;
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Xem lai
  bool _contains(List<Type> listenTypes, Type type) {
    for (Type t in listenTypes) {
      if (t == type) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  // Private Method. Only for use in this class.
  void __findEventShelfCascade({
    required Block listenerBlock,
    required Map<String, Shelf> foundShelfMap,
  }) {
    List<Type> listenTypes = listenerBlock.getOutsideDataTypesToListen();

    for (Shelf shelf in __shelfMap.values) {
      if (shelf == listenerBlock.shelf) {
        continue;
      }
      List<Block> allBlocks = shelf.blocks;
      for (Block blk in allBlocks) {
        if (blk.config.outsideBroadcast == null) {
          continue;
        }
        final Type itemType = blk.getItemType();
        final Type itemDetailType = blk.getItemDetailType();
        if (_contains(listenTypes, itemType) ||
            _contains(listenTypes, itemDetailType)) {
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

  // ***************************************************************************
  // ***************************************************************************

  Map<String, Shelf> debugGetListenerShelves() {
    return _getListenerShelves();
  }

  Map<String, Shelf> debugGetEventShelves({required bool external}) {
    return _getEventShelves(external: external);
  }

  Map<String, Shelf> debugGetIndependentShelves({required bool external}) {
    return _getIndependentShelves(external: external);
  }

  // ***************************************************************************
  // ***************************************************************************

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

  // ***************************************************************************
  // ***************************************************************************

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

  // ***************************************************************************
  // ***************************************************************************

  List<Block> _getListenerBlocksByShelf({
    required Shelf eventShelf,
    required bool external,
  }) {
    // FullName, Block
    Map<String, Block> foundMap = {};
    //
    for (Block eventBlock in eventShelf.blocks) {
      List<Block> listenerBlocks = __getListenerBlocksByBlock(
        eventBlock: eventBlock,
        external: external,
      );
      for (var lb in listenerBlocks) {
        foundMap[lb._shortPathName] = lb;
      }
    }
    return foundMap.values.toList();
  }

  // ***************************************************************************
  // ***************************************************************************

  List<Scalar> _getListenerScalarsByShelf({
    required Shelf eventShelf,
    required bool external,
  }) {
    // FullName, Scalar
    Map<String, Scalar> foundMap = {};
    //
    for (Block eventBlock in eventShelf.blocks) {
      List<Scalar> listenerScalars = __getListenerScalarsByBlock(
        eventBlock: eventBlock,
        external: external,
      );
      for (var scalar in listenerScalars) {
        foundMap[scalar._shortPathName] = scalar;
      }
    }
    return foundMap.values.toList();
  }

  // ***************************************************************************
  // ***************************************************************************

  // Callable.
  List<Block> __getListenerBlocksByAffectedItemTypes({
    required Shelf eventShelf,
    required List<Type> affectedItemTypes,
  }) {
    // FullName, Block
    Map<String, Block> foundMap = {};

    for (String shelfName in __shelfMap.keys) {
      Shelf? shelf = __shelfMap[shelfName];
      if (shelf == null) {
        continue;
      }
      for (Block blockToCheck in shelf.blocks) {
        for (Type affectedItemType in affectedItemTypes) {
          if (_contains(
            blockToCheck.getOutsideDataTypesToListen(),
            affectedItemType,
          )) {
            foundMap[blockToCheck._shortPathName] = blockToCheck;
            break;
          }
        }
      }
    }
    return foundMap.values.toList();
  }

  // ***************************************************************************
  // ***************************************************************************

  // Callable.
  List<Block> __getListenerBlocksByBlock({
    required Block eventBlock,
    required bool external,
  }) {
    List<Type> itemTypes = eventBlock._getBroadcastDataTypes(
      external: external,
    );
    if (itemTypes.isEmpty) {
      return [];
    }
    //
    List<Block> blockList = __getListenerBlocksByAffectedItemTypes(
      eventShelf: eventBlock.shelf,
      affectedItemTypes: itemTypes,
    );
    return blockList
        .where((block) => !identical(block.shelf, eventBlock.shelf))
        .toList();
  }

  // ***************************************************************************
  // ***************************************************************************

  List<Scalar> __getListenerScalarsByAffectedItemTypes({
    required Shelf eventShelf,
    required List<Type> affectedItemTypes,
    required bool external,
  }) {
    // FullName, Scalar
    Map<String, Scalar> foundMap = {};

    if (external) {
      for (String shelfName in __shelfMap.keys) {
        Shelf? shelf = __shelfMap[shelfName];
        if (shelf == null || identical(shelf, eventShelf)) {
          continue;
        }
        for (Scalar scalar in shelf.scalars) {
          List<Type> listenerTypes = scalar.getOutsideDataTypesToListen(
            external: true,
          );
          for (Type affectedItemType in affectedItemTypes) {
            if (_contains(listenerTypes, affectedItemType)) {
              foundMap[scalar._shortPathName] = scalar;
              break;
            }
          }
        }
      }
      return foundMap.values.toList();
    }
    // Internal:
    else {
      for (Scalar scalar in eventShelf.scalars) {
        List<Type> listenerTypes = scalar.getOutsideDataTypesToListen(
          external: false,
        );
        for (Type affectedItemType in affectedItemTypes) {
          if (_contains(listenerTypes, affectedItemType)) {
            foundMap[scalar._shortPathName] = scalar;
            break;
          }
        }
      }
      return foundMap.values.toList();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  List<Scalar> __getListenerScalarsByBlock({
    required Block eventBlock,
    required bool external,
  }) {
    List<Type> itemTypes = eventBlock._getBroadcastDataTypes(
      external: external,
    );
    if (itemTypes.isEmpty) {
      return [];
    }
    //
    List<Scalar> scalarList = __getListenerScalarsByAffectedItemTypes(
      eventShelf: eventBlock.shelf,
      affectedItemTypes: itemTypes,
      external: external,
    );
    return scalarList
        .where((scalar) => !identical(scalar.shelf, eventBlock.shelf))
        .toList();
  }

  // ***************************************************************************
  // ***************************************************************************

  // Callable.
  List<ShelfBlockScalarType> getListenerShelfBlockScalarTypes({
    required BlockOrScalar eventBlockOrScalar,
    required bool external,
  }) {
    if (external) {
      if (eventBlockOrScalar.block != null) {
        List<Block> listenerBlocks = __getListenerBlocksByBlock(
          eventBlock: eventBlockOrScalar.block!,
          external: external,
        );
        List<Scalar> listenerScalars = __getListenerScalarsByBlock(
          eventBlock: eventBlockOrScalar.block!,
          external: external,
        );
        //
        List<ShelfBlockScalarType> foundShelfBlockTypes = [];
        for (Block listenerBlock in listenerBlocks) {
          foundShelfBlockTypes.add(
            ShelfBlockScalarType.block(
              shelfType: listenerBlock.shelf.runtimeType,
              blockType: listenerBlock.runtimeType,
              classDefinition: listenerBlock.debugClassDefinition,
              classParameterDefinition:
                  listenerBlock.debugClassParametersDefinition,
            ),
          );
        }
        for (Scalar listenerScalar in listenerScalars) {
          foundShelfBlockTypes.add(
            ShelfBlockScalarType.scalar(
              shelfType: listenerScalar.shelf.runtimeType,
              scalarType: listenerScalar.runtimeType,
              classDefinition: listenerScalar.debugClassDefinition,
              classParameterDefinition:
                  listenerScalar.debugClassParametersDefinition,
            ),
          );
        }
        return foundShelfBlockTypes;
      } else {
        return [];
      }
    } else {
      throw UnimplementedError();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  // Callable.
  List<Block> _getEventBlocksByBlock({
    required Block listenerBlock,
  }) {
    // FullName, Block
    Map<String, Block> foundMap = {};

    for (Shelf shelf in __shelfMap.values) {
      List<Block> allBlocks = shelf.blocks;
      for (Block blk in allBlocks) {
        if (blk.config.outsideBroadcast == null) {
          continue;
        }
        final List<Type> listenToDataTypes =
            listenerBlock.getOutsideDataTypesToListen();
        final Type itemType = blk.getItemType();
        final Type itemDetailType = blk.getItemDetailType();
        if (_contains(listenToDataTypes, itemType) ||
            _contains(listenToDataTypes, itemDetailType)) {
          foundMap[blk._shortPathName] = blk;
        }
      }
    }
    return foundMap.values.toList();
  }

  // ***************************************************************************
  // ***************************************************************************

  // Callable.
  List<Block> _getEventBlocksByScalar({
    required Scalar listenerScalar,
  }) {
    // FullName, Block
    Map<String, Block> foundMap = {};

    for (Shelf shelf in __shelfMap.values) {
      for (Block blk in shelf.blocks) {
        if (blk.config.outsideBroadcast == null) {
          continue;
        }
        ScalarOutsideEventReaction? outsideReaction =
            listenerScalar.config.outsideEventReaction;
        if (outsideReaction == null) {
          continue;
        }
        final List<Type> listenerTypes = outsideReaction.getDataEventTypes();
        final Type itemType = blk.getItemType();
        final Type itemDetailType = blk.getItemDetailType();
        if (_contains(listenerTypes, itemType) ||
            _contains(listenerTypes, itemDetailType)) {
          foundMap[blk._shortPathName] = blk;
        }
      }
    }
    return foundMap.values.toList();
  }

  // ***************************************************************************
  // ***************************************************************************

  // Callable.
  List<ShelfBlockScalarType> getEventShelfBlockTypes({
    required BlockOrScalar listenerBlockOrScalar,
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
          classDefinition: eventBlock.debugClassDefinition,
          classParameterDefinition: eventBlock.debugClassParametersDefinition,
        ),
      );
    }
    return foundEventShelfBlockTypes;
  }

  // ***************************************************************************
  // ***************************************************************************

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

  // ***************************************************************************
  // ***************************************************************************

  void _checkToRemoveShelf(Shelf shelf) {
    bool hasMountedUIComponent = shelf.hasMountedUIComponent();
    if (!hasMountedUIComponent) {
      print(">>>>>>>>>>> Shelf: ${getClassName(shelf)} dispose all component");
      FlutterArtist.codeFlowLogger.addInfo(
        ownerClassInstance: this,
        info: "Shelf: ${getClassName(shelf)} dispose all UI components",
      );
      if (shelf.hiddenBehavior == ShelfHiddenBehavior.clear) {
        print(
            "  ---------> Remove ${getClassName(shelf)} from FlutterArtist Storage");
        __shelfMap.remove(shelf.name);
      } else {
        print("  ---------> Do Nothing");
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Shelf? _recentShelf() {
    return _rencentShelves.isEmpty ? null : _rencentShelves.first;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> __executeListeners({
    required List<Scalar> listenerScalars,
    required List<Block> listenerBlocks,
  }) async {
    if (listenerScalars.isNotEmpty) {
      print(">> ~~~~~~~~~~~~~~~~~~~~~~~~> listenerScalars: $listenerScalars");
    }
    if (listenerBlocks.isNotEmpty) {
      print(">> ~~~~~~~~~~~~~~~~~~~~~~~~> listenerBlocks: $listenerBlocks");
    }
    for (Scalar listenerScalar in listenerScalars) {
      if (!listenerScalar.hasActiveUIComponent()) {
        listenerScalar.setToPending();
      }
    }
    // <String shelfName>
    Map<String, _ScalarAndBlockList> queryMap = {};

    for (Scalar listenerScalar in listenerScalars) {
      if (listenerScalar.hasActiveUIComponent()) {
        String shelfName = listenerScalar.shelf.name;
        _ScalarAndBlockList sbList =
            queryMap[shelfName] ?? _ScalarAndBlockList();
        queryMap[shelfName] = sbList;
        sbList.queryScalars.add(listenerScalar);
      }
    }

    for (Block listenerBlock in listenerBlocks) {
      // TODO: Doi thanh hasActiveUiComponents()??
      final bool active = listenerBlock.hasActiveBlockFragmentWidget(
        alsoCheckChildren: true,
      );
      if (!active) {
        listenerBlock.setToPending();
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
    if (queryMap.isNotEmpty) {
      print("|~~~~~~~~~~~~~~~~~~~~~~> Query Listeners: ${queryMap.keys}");
      //
      FlutterArtist.codeFlowLogger._addInfo(
        ownerClassInstance: this,
        info: "Query Listeners: ${queryMap.keys}",
        isLibCode: true,
      );
    }
    for (String shelfName in queryMap.keys) {
      Shelf shelf = __shelfMap[shelfName]!;
      _ScalarAndBlockList sbList = queryMap[shelfName]!;
      //
      await shelf._queryAll(
        forceFilterModelOpt: null,
        forceQueryScalarOpts: sbList.queryScalars
            .map(
              (s) => _ScalarOpt(scalar: s),
            )
            .toList(),
        forceQueryBlockOpts: sbList.queryBlocks
            .map(
              (b) => _BlockOpt(
                  block: b,
                  forceQuery: true,
                  forceReloadItem: true,
                  pageable: null,
                  listBehavior: null,
                  suggestedSelection: null,
                  postQueryBehavior: null),
            )
            .toList(),
        forceQueryFormModelOpts: [],
      );
    }
  }
}
