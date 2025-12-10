part of '../core.dart';

class _StorageEventHandler {
  final _Storage storage;

  _StorageEventHandler(this.storage);

  // ***************************************************************************
  // ***************************************************************************

  @_ImportantMethodAnnotation("Called after saving or deleting in the Block")
  void _fireEventFromBlockToOtherShelves({
    required MasterFlowItem? masterFlowItem,
    required EventType eventType,
    required Block eventBlock,
    required String? itemIdString,
  }) {
    List<Event> events = eventBlock.config.outsideBroadcastEvents;
    if (events.isEmpty) {
      masterFlowItem?._addLineFlowItem(
        codeId: "#25000",
        shortDesc:
            "${debugObjHtml(eventBlock)}.config.outsideBroadcastEvents is empty! --> This event will be ignored.",
        lineFlowType: LineFlowType.debug,
      );
      return;
    }
    // Appends TaskUnits to QUEUE (No need to call execute).
    ___fireEventFromBlockToOtherShelves(
      masterFlowItem: masterFlowItem,
      eventType: eventType,
      srcEventBlock: eventBlock,
      events: eventBlock.config.outsideBroadcastEvents,
      itemIdString: itemIdString,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  // PRIVATE METHOD.
  void ___fireEventFromBlockToOtherShelves({
    required MasterFlowItem? masterFlowItem,
    required EventType eventType,
    required Block? srcEventBlock,
    required List<Event> events,
    required dynamic itemIdString,
  }) {
    // Never run.
    if (events.isEmpty) {
      masterFlowItem?._addLineFlowItem(
        codeId: "#26000",
        shortDesc: "Events is empty! --> This event will be ignored.",
        lineFlowType: LineFlowType.eventInfo,
      );
      return;
    }
    Type itemDetailType = events.first.dataType;
    //
    masterFlowItem?._addLineFlowItem(
      codeId: "#26100",
      shortDesc: "Creating <b>QueuedEvent</b> and add to the queue.",
      parameters: {
        "eventType": eventType,
        "eventShelf": srcEventBlock?.shelf,
        "events": events,
        "itemId": itemIdString,
      },
      lineFlowType: LineFlowType.eventInfo,
    );
    //
    final QueuedEvent queuedEvent = QueuedEvent(
      eventType: eventType,
      eventShelf: srcEventBlock?.shelf,
      events: events,
      itemId: itemIdString,
    );
    //
    masterFlowItem?._addLineFlowItem(
      codeId: "#26120",
      shortDesc:
          "The <b>QueuedEvent</b> is created, It will be executed later....",
      lineFlowType: LineFlowType.eventInfo,
    );
    //
    storage._queuedEventManager.addQueuedEvent(queuedEvent);
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ImportantMethodAnnotation(
      "Called after executing QuickAction in the Block or Scalar")
  void _fireEventFromShelfToOtherShelves({
    required MasterFlowItem masterFlowItem,
    required EventType eventType,
    required Shelf? eventShelf,
    required List<Event> events,
  }) {
    if (events.isEmpty) {
      masterFlowItem._addLineFlowItem(
        codeId: "#60000",
        shortDesc: "Events is empty! --> This event will be ignored.",
        lineFlowType: LineFlowType.eventInfo,
      );
      return;
    }
    Type itemDetailType = events.first.dataType;
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#60100",
      shortDesc: "Creating <b>$QueuedEvent</b> and add to queue.",
      parameters: {
        "eventType": eventType,
        "eventShelf": eventShelf,
        "events": events,
      },
      lineFlowType: LineFlowType.eventInfo,
    );
    //
    final QueuedEvent queuedEvent = QueuedEvent(
      eventType: eventType,
      eventShelf: eventShelf,
      events: events,
      itemId: null,
    );
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#26120",
      shortDesc:
          "<b>$QueuedEvent</b> is created, It will be executed later....",
      lineFlowType: LineFlowType.eventInfo,
    );
    //
    storage._queuedEventManager.addQueuedEvent(queuedEvent);
  }

  // ***************************************************************************
  // ***************************************************************************

  List<Scalar> __getListenerScalarsByBlock({
    required Block eventBlock,
  }) {
    List<Event> itemTypeEvents = eventBlock.config.outsideBroadcastEvents;
    if (itemTypeEvents.isEmpty) {
      return [];
    }
    //
    List<Scalar> scalarList = __getListenerScalarsByAffectedItemTypes(
      eventShelf: eventBlock.shelf,
      affectedItemTypeEvents: itemTypeEvents,
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
    List<Event> itemTypeEvents = eventBlock.config.outsideBroadcastEvents;
    if (itemTypeEvents.isEmpty) {
      return [];
    }
    //
    List<Block> blockList = __getListenerBlocksByAffectedItemTypes(
      eventShelf: eventBlock.shelf,
      affectedItemTypeEvents: itemTypeEvents,
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
    required List<Event> affectedItemTypeEvents,
  }) {
    // FullName, Block
    Map<String, Block> foundMap = {};

    for (String shelfName in storage.activeShelfNames) {
      Shelf? shelf = storage.findShelfByName(shelfName);
      if (shelf == null) {
        continue;
      }
      for (Block blockToCheck in shelf.blocks) {
        for (Event affectedItemTypeEvent in affectedItemTypeEvents) {
          if (_contains(
            blockToCheck.getOutsideDataTypesToListen(),
            affectedItemTypeEvent,
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
    required List<Event> affectedItemTypeEvents,
  }) {
    // FullName, Scalar
    Map<String, Scalar> foundMap = {};

    for (String shelfName in storage.activeShelfNames) {
      print("@~~~~~~~~~~~~> shelfName: $shelfName ");
      Shelf? shelf = storage.findShelfByName(shelfName);
      print("@~~~~~~~~~~~~> shelfName: $shelfName --> shelf: $shelf");
      if (shelf == null || identical(shelf, eventShelf)) {
        continue;
      }
      for (Scalar scalar in shelf.scalars) {
        List<Event> listenerTypeEvents = scalar.getOutsideDataTypesToListen();
        for (Event affectedItemTypeEvent in affectedItemTypeEvents) {
          if (_contains(listenerTypeEvents, affectedItemTypeEvent)) {
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
        final List<Event> listenToDataTypes =
            listenerBlock.getOutsideDataTypesToListen();
        final Event itemTypeEvent = Event(blk.getItemType());
        final Event itemDetailTypeEvent = Event(blk.getItemDetailType());
        if (_contains(listenToDataTypes, itemTypeEvent) ||
            _contains(listenToDataTypes, itemDetailTypeEvent)) {
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
        List<Event> listenerTypes =
            listenerScalar.config.executeScalarLevelReactionToEvents;
        if (listenerTypes.isEmpty) {
          continue;
        }
        final Event itemTypeEvent = Event(blk.getItemType());
        final Event itemDetailTypeEvent = Event(blk.getItemDetailType());
        if (_contains(listenerTypes, itemTypeEvent) ||
            _contains(listenerTypes, itemDetailTypeEvent)) {
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
    for (String shelfName in storage.activeShelfNames) {
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
  bool _contains(List<Event> listenTypeEvents, Event event) {
    for (Event e in listenTypeEvents) {
      if (e.dataType == event.dataType) {
        return true;
      }
    }
    return false;
  }
}
