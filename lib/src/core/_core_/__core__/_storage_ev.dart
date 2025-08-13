part of '../core.dart';

class _StorageEventHandler {
  final _Storage storage;

  _StorageEventHandler(this.storage);

  // ***************************************************************************
  // ***************************************************************************

  @DebugMethodAnnotation()
  void debugFireEventSourceChanged({required List<Type> outsideEventTypes}) {
    if (!FlutterArtist.testCaseMode) {
      throw FatalAppError(errorMessage: "Not Test Case Mode");
    }
    __fireEventSourceChanged(
      eventBlock: null,
      outsideEventTypes: outsideEventTypes,
      itemIdString: null,
    );
    print("QUEUE: ${FlutterArtist._taskUnitQueue}");
    FlutterArtist.executor._executeTaskUnitQueue();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ImportantMethodAnnotation("Called after saving or deleting in the Block")
  void _fireEventSourceChanged({
    required Block eventBlock,
    required String? itemIdString,
  }) {
    // Appends TaskUnits to QUEUE (No need to call execute).
    __fireEventSourceChanged(
      eventBlock: eventBlock,
      outsideEventTypes: eventBlock.config.outsideBroadcastEvents,
      itemIdString: itemIdString,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  // PRIVATE METHOD.
  void __fireEventSourceChanged({
    required Block? eventBlock,
    required List<Type> outsideEventTypes,
    required String? itemIdString,
  }) {
    if (outsideEventTypes.isEmpty) {
      print(
          "~~~~~~~~~> NOT FIRE EVENT TO OUTSIDE --> Event Item Types: $outsideEventTypes"
          " - ${getClassName(eventBlock)}");
      return;
    } else {
      print(
          "~~~~~~~~~> FIRE EVENT TO OUTSIDE --> Event Item Types: $outsideEventTypes"
          " - ${getClassName(eventBlock)}");
    }
    //
    for (String shelfName in storage._shelfMap.keys) {
      if (shelfName == eventBlock?.shelf.name) {
        continue;
      }
      Shelf shelf = storage._shelfMap[shelfName]!;
      if (shelf.isFullyPending) {
        continue;
      }
      EffectedShelfMembers effectedShelfMembers =
          shelf._calculateEffectedShelfMembersByEvents(outsideEventTypes);

      if (!effectedShelfMembers.hasMember()) {
        continue;
      }
      shelf._addShelfQueryTaskUnit(effectedShelfMembers: effectedShelfMembers);
    }
    // //
    // final List<Scalar> listenerScalars = __getListenerScalarsByBlock(
    //   eventBlock: eventBlock,
    // );
    // //
    // final List<Block> listenerBlocks = __getListenerBlocksByBlock(
    //   eventBlock: eventBlock,
    // );
    // print(
    //     "~~~~~~~~~> listenerBlocks: $listenerBlocks, listenerScalars: $listenerScalars");
    // //
    // // TODO: Add to QUEUE lazy.
    // //
    // if (listenerScalars.isNotEmpty || listenerBlocks.isNotEmpty) {
    //   __executeExternalListenersOfShelf(
    //     listenerScalars: listenerScalars,
    //     listenerBlocks: listenerBlocks,
    //   );
    // }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ImportantMethodAnnotation(
      "Called after executing QuickAction in the Block or Scalar")
  void _fireEventToAffectedItemTypes({
    required Shelf eventShelf,
    required List<Type> affectedItemTypes,
  }) {
    final List<Scalar> listenerScalars =
        __getListenerScalarsByAffectedItemTypes(
      eventShelf: eventShelf,
      affectedItemTypes: affectedItemTypes,
    );
    //
    final List<Block> listenerBlocks = __getListenerBlocksByAffectedItemTypes(
      eventShelf: eventShelf,
      affectedItemTypes: affectedItemTypes,
    );
    //
    __executeExternalListenersOfShelf(
      listenerScalars: listenerScalars,
      listenerBlocks: listenerBlocks,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  List<Scalar> __getListenerScalarsByBlock({
    required Block eventBlock,
  }) {
    List<Type> itemTypes = eventBlock.config.outsideBroadcastEvents;
    if (itemTypes.isEmpty) {
      return [];
    }
    //
    List<Scalar> scalarList = __getListenerScalarsByAffectedItemTypes(
      eventShelf: eventBlock.shelf,
      affectedItemTypes: itemTypes,
    );
    return scalarList
        .where((scalar) => !identical(scalar.shelf, eventBlock.shelf))
        .toList();
  }

  // ***************************************************************************
  // ***************************************************************************

  List<Block> _getListenerBlocksByShelf({
    required Shelf eventShelf,
  }) {
    // FullName, Block
    Map<String, Block> foundMap = {};
    //
    for (Block eventBlock in eventShelf.blocks) {
      List<Block> listenerBlocks = __getListenerBlocksByBlock(
        eventBlock: eventBlock,
      );
      for (var lb in listenerBlocks) {
        foundMap[lb._shortPathName] = lb;
      }
    }
    return foundMap.values.toList();
  }

  // ***************************************************************************
  // ***************************************************************************

  // Callable.
  List<Block> __getListenerBlocksByBlock({
    required Block eventBlock,
  }) {
    List<Type> itemTypes = eventBlock.config.outsideBroadcastEvents;
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

  // Callable.
  List<Block> __getListenerBlocksByAffectedItemTypes({
    required Shelf eventShelf,
    required List<Type> affectedItemTypes,
  }) {
    // FullName, Block
    Map<String, Block> foundMap = {};

    for (String shelfName in storage.shelfNames) {
      Shelf? shelf = storage.findShelfByName(shelfName);
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

  List<Scalar> __getListenerScalarsByAffectedItemTypes({
    required Shelf eventShelf,
    required List<Type> affectedItemTypes,
  }) {
    // FullName, Scalar
    Map<String, Scalar> foundMap = {};

    for (String shelfName in storage.shelfNames) {
      Shelf? shelf = storage.findShelfByName(shelfName);
      if (shelf == null || identical(shelf, eventShelf)) {
        continue;
      }
      for (Scalar scalar in shelf.scalars) {
        List<Type> listenerTypes = scalar.getOutsideDataTypesToListen();
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

  // ***************************************************************************
  // ***************************************************************************

  // Callable.
  List<Block> _getEventBlocksByBlock({
    required Block listenerBlock,
  }) {
    // FullName, Block
    Map<String, Block> foundMap = {};

    for (Shelf shelf in storage.getAllShelves()) {
      List<Block> allBlocks = shelf.blocks;
      for (Block blk in allBlocks) {
        if (blk.config.outsideBroadcastEvents.isEmpty) {
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

  // Private Method. Only for use in this class.
  void __findEventShelfCascade({
    required Block listenerBlock,
    required Map<String, Shelf> foundShelfMap,
  }) {
    List<Type> listenTypes = listenerBlock.getOutsideDataTypesToListen();

    for (Shelf shelf in storage.getAllShelves()) {
      if (shelf == listenerBlock.shelf) {
        continue;
      }
      List<Block> allBlocks = shelf.blocks;
      for (Block blk in allBlocks) {
        if (blk.config.outsideBroadcastEvents.isEmpty) {
          continue;
        }
        final Type itemType = blk.getItemType();
        final Type itemDetailType = blk.getItemDetailType();
        if (_contains(listenTypes, itemType) ||
            _contains(listenTypes, itemDetailType)) {
          String shelfType = storage._getShelfName(shelf.runtimeType);
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

  List<Scalar> _getListenerScalarsByShelf({
    required Shelf eventShelf,
  }) {
    // FullName, Scalar
    Map<String, Scalar> foundMap = {};
    //
    for (Block eventBlock in eventShelf.blocks) {
      List<Scalar> listenerScalars = __getListenerScalarsByBlock(
        eventBlock: eventBlock,
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
  List<Block> _getEventBlocksByScalar({
    required Scalar listenerScalar,
  }) {
    // FullName, Block
    Map<String, Block> foundMap = {};

    for (Shelf shelf in storage.getAllShelves()) {
      for (Block blk in shelf.blocks) {
        if (blk.config.outsideBroadcastEvents.isEmpty) {
          continue;
        }
        List<Type> listenerTypes =
            listenerScalar.config.reQueryByExternalShelfEvents;
        if (listenerTypes.isEmpty) {
          continue;
        }
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

  // @Callable
  Map<String, Shelf> _getListenerShelves() {
    // Name, Shelf
    Map<String, Shelf> foundShelfMap = {};
    //
    for (String shelfName in storage.shelfNames) {
      Shelf? listenerShelf = storage.findShelfByName(shelfName);
      if (listenerShelf == null) {
        continue;
      }

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

  // Callable.
  List<ShelfBlockScalarType> getListenerShelfBlockScalarTypes({
    required BlockOrScalar eventBlockOrScalar,
  }) {
    if (eventBlockOrScalar.block != null) {
      List<Block> listenerBlocks = __getListenerBlocksByBlock(
        eventBlock: eventBlockOrScalar.block!,
      );
      List<Scalar> listenerScalars = __getListenerScalarsByBlock(
        eventBlock: eventBlockOrScalar.block!,
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
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> __executeExternalListenersOfShelf({
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
      if (!listenerScalar.ui.hasActiveUIComponent()) {
        listenerScalar.setToPending();
      }
    }
    // <String shelfName>
    Map<String, _ScalarAndBlockList> queryMap = {};

    for (Scalar listenerScalar in listenerScalars) {
      if (listenerScalar.ui.hasActiveUIComponent()) {
        String shelfName = listenerScalar.shelf.name;
        _ScalarAndBlockList sbList =
            queryMap[shelfName] ?? _ScalarAndBlockList();
        queryMap[shelfName] = sbList;
        sbList.queryScalars.add(listenerScalar);
      }
    }

    for (Block listenerBlock in listenerBlocks) {
      // TODO: Use hasActiveUiComponents()??
      final bool active = listenerBlock.ui.hasActiveBlockFragmentWidget(
        alsoCheckChildren: true,
      );
      if (!active) {
        listenerBlock.setToPending();
      }
    }

    // xxx;
    for (Block listenerBlock in listenerBlocks) {
      // TODO: Use hasActiveUiComponents()??
      final bool active = listenerBlock.ui.hasActiveBlockFragmentWidget(
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
      Shelf shelf = storage.findShelfByName(shelfName)!;
      _ScalarAndBlockList sbList = queryMap[shelfName]!;
      //
      await shelf._queryShelf(
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
                  forceQuery: QryHint.force,
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

  // ***************************************************************************
  // ***************************************************************************

  // @Callable
  Map<String, Shelf> _getIndependentShelves() {
    Map<String, Shelf> eventMap = _getEventShelves();
    Map<String, Shelf> listenerMap = _getListenerShelves();
    Map<String, Shelf> map = {}..addAll(storage._shelfMap);
    map.removeWhere(
      (shelfName, shelf) =>
          eventMap.keys.contains(shelfName) ||
          listenerMap.keys.contains(shelfName),
    );
    return map;
  }

  // ***************************************************************************
  // ***************************************************************************

  // @Callable
  Map<String, Shelf> _getEventShelves() {
    // Name, Shelf
    Map<String, Shelf> foundEventShelfMap = {};
    //
    for (Shelf shelf in storage.getAllShelves()) {
      List<Block> listenerBlocks = _getListenerBlocksByShelf(
        eventShelf: shelf,
      );
      if (listenerBlocks.isNotEmpty) {
        foundEventShelfMap[shelf.name] = shelf;
        continue;
      }
      List<Scalar> listenerScalars = _getListenerScalarsByShelf(
        eventShelf: shelf,
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

  @DebugMethodAnnotation()
  Map<String, Shelf> debugGetListenerShelves() {
    return _getListenerShelves();
  }

  @DebugMethodAnnotation()
  Map<String, Shelf> debugGetEventShelves() {
    return _getEventShelves();
  }

  @DebugMethodAnnotation()
  Map<String, Shelf> debugGetIndependentShelves() {
    return _getIndependentShelves();
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
}
