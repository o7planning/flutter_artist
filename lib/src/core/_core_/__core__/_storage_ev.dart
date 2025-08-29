part of '../core.dart';

class _StorageEventHandler {
  final _Storage storage;

  _StorageEventHandler(this.storage);

  // ***************************************************************************
  // ***************************************************************************

  @DebugMethodAnnotation()
  void debugFireEventsToOtherShelves({required List<Type> events}) {
    if (!FlutterArtist.testCaseMode) {
      throw FatalAppError(errorMessage: "Not Test Case Mode");
    }
    ___fireEventFromBlockToOtherShelves(
      eventBlock: null,
      events: events,
      itemIdString: null,
    );
    print("QUEUE: ${FlutterArtist._rootQueue}");
    FlutterArtist.executor._executeTaskUnitQueue();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ImportantMethodAnnotation("Called after saving or deleting in the Block")
  void _fireEventFromBlockToOtherShelves({
    required Block eventBlock,
    required String? itemIdString,
  }) {
    // Appends TaskUnits to QUEUE (No need to call execute).
    ___fireEventFromBlockToOtherShelves(
      eventBlock: eventBlock,
      events: eventBlock.config.outsideBroadcastEvents,
      itemIdString: itemIdString,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  // PRIVATE METHOD.
  void ___fireEventFromBlockToOtherShelves({
    required Block? eventBlock,
    required List<Type> events,
    required String? itemIdString,
  }) {
    if (events.isEmpty) {
      print("*~~~~~~~~~> NO EVENT FIRE TO OUTSIDE --> Event Item Types: $events"
          " - Src Event: ${getClassName(eventBlock)}");
      return;
    } else {
      print("*~~~~~~~~~> FIRE EVENT TO OUTSIDE --> Event Item Types: $events"
          " - Src Event: ${getClassName(eventBlock)}");
    }
    //
    for (String shelfName in storage._shelfMap.keys) {
      if (shelfName == eventBlock?.shelf.name) {
        continue;
      }
      Shelf listenerShelf = storage._shelfMap[shelfName]!;
      //
      __addReactionTaskUnitToEvents(
        listenerShelf: listenerShelf,
        outsideEvents: events,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ImportantMethodAnnotation(
      "Called after executing QuickAction in the Block or Scalar")
  void _fireEventFromShelfToOtherShelves({
    required Shelf? eventShelf,
    required List<Type> events,
  }) {
    if (events.isEmpty) {
      print(
          "**~~~~~~~~~> NO EVENT FIRE TO OUTSIDE --> Event Item Types: $events"
          " - Src Shelf: ${getClassName(eventShelf)}");
      return;
    } else {
      print("**~~~~~~~~~> FIRE EVENT TO OUTSIDE --> Event Item Types: $events"
          " - Src Shelf: ${getClassName(eventShelf)}");
    }
    //
    for (String shelfName in storage._shelfMap.keys) {
      if (shelfName == eventShelf?.name) {
        continue;
      }
      Shelf listenerShelf = storage._shelfMap[shelfName]!;
      //
      __addReactionTaskUnitToEvents(
        listenerShelf: listenerShelf,
        outsideEvents: events,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __addReactionTaskUnitToEvents({
    required Shelf listenerShelf,
    required List<Type> outsideEvents,
  }) {
    if (listenerShelf.isFullyPending) {
      return;
    }
    EffectedShelfMembers effectedShelfMembers =
        listenerShelf._calculateEffectedShelfMembersByEvents(outsideEvents);

    if (!effectedShelfMembers.hasMember()) {
      return;
    }
    listenerShelf._addShelfExternalReactionTaskUnit(
      effectedShelfMembers: effectedShelfMembers,
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
