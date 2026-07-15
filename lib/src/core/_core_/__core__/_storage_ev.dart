part of '../core.dart';

class _StorageEventHandler {
  final _Storage storage;

  _StorageEventHandler(this.storage);

  // ***************************************************************************
  // ***************************************************************************

  @_ImportantMethodAnnotation("Called after saving or deleting in the Block")
  void _broadcastEventFromBlockToOtherShelves1({
    required ExecutionTrace executionTrace,
    required EventType eventType,
    required Block eventBlock,
    required String? itemIdString,
  }) {
    // final List<Type> events = eventBlock.config.broadcastExternalShelfEvents;
    // if (events.isEmpty) {
    //   executionTrace._addTraceStep(
    //     codeId: "#25000",
    //     shortDesc:
    //         "${debugObjHtml(eventBlock)}.broadcastExternalShelfEvents is empty! "
    //             "--> Cancel to broadcast events from this block to other shelves.",
    //     traceStepType: TraceStepType.debug,
    //   );
    //   return;
    // }
    // // Appends TaskUnits to QUEUE (No need to call execute).
    // ___broadcastEventFromBlockToOtherShelves(
    //   executionTrace: executionTrace,
    //   eventType: eventType,
    //   srcEventBlock: eventBlock,
    //   events: events,
    //   itemIdString: itemIdString,
    // );
    throw UnimplementedError();
  }

  // ***************************************************************************
  // ***************************************************************************

  // PRIVATE METHOD.
  void ___broadcastEventFromBlockToOtherShelves({
    required ExecutionTrace executionTrace,
    required EventType eventType,
    required Block? srcEventBlock,
    required List<Type> events,
    required dynamic itemIdString,
  }) {
    // Never run.
    if (events.isEmpty) {
      executionTrace._addTraceStep(
        codeId: "#26000",
        shortDesc: "Events list is empty! --> This event will be ignored.",
        traceStepType: TraceStepType.eventInfo,
      );
      return;
    }

    executionTrace._addTraceStep(
      codeId: "#26100",
      shortDesc: "Creating <b>DeferredEvent</b> and add to the queue.",
      parameters: {
        "eventType": eventType,
        "eventShelf": srcEventBlock?.shelf,
        "events": events,
        "itemId": itemIdString,
      },
      traceStepType: TraceStepType.eventInfo,
    );
    //
    // Note: If DeferredEvent class still requires old Event object layer,
    // modify its constructor later to accept List<Type> directly.
    final DeferredEvent deferredEvent = DeferredEvent(
      eventType: eventType,
      eventShelf: srcEventBlock?.shelf,
      events: events,
      itemId: itemIdString,
    );
    //
    executionTrace._addTraceStep(
      codeId: "#26120",
      shortDesc:
          "The <b>${getTypeNameWithoutGenerics(DeferredEvent)}</b> is created, It will be executed later....",
      traceStepType: TraceStepType.eventInfo,
    );
    //
    storage._deferredEventManager.addDeferredEvent(deferredEvent);
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ImportantMethodAnnotation(
      "Called after executing QuickAction in the Block or Scalar")
  void _broadcastEventFromShelfToOtherShelves({
    required ExecutionTrace executionTrace,
    required EventType eventType,
    required Shelf? eventShelf,
    required List<Type> events,
  }) {
    if (events.isEmpty) {
      executionTrace._addTraceStep(
        codeId: "#60000",
        shortDesc: "Events list is empty! --> This event will be ignored.",
        traceStepType: TraceStepType.eventInfo,
      );
      return;
    }

    executionTrace._addTraceStep(
      codeId: "#60100",
      shortDesc:
          "Creating <b>${getTypeNameWithoutGenerics(DeferredEvent)}</b> and add to queue.",
      parameters: {
        "eventType": eventType,
        "eventShelf": eventShelf,
        "events": events,
      },
      traceStepType: TraceStepType.eventInfo,
    );
    //
    final DeferredEvent deferredEvent = DeferredEvent(
      eventType: eventType,
      eventShelf: eventShelf,
      events: events,
      itemId: null,
    );
    //
    executionTrace._addTraceStep(
      codeId: "#60200",
      shortDesc:
          "The <b>${getTypeNameWithoutGenerics(DeferredEvent)}</b> is created, It will be executed later....",
      traceStepType: TraceStepType.eventInfo,
    );
    //
    storage._deferredEventManager.addDeferredEvent(deferredEvent);
  }

  // ***************************************************************************
  // ***************************************************************************

  List<Scalar> __getListenerScalarsByBlock({
    required Block eventBlock,
  }) {
    // Set<Type> itemTypeEvents = eventBlock.getResolvedBroadcastDataTypes();
    // if (itemTypeEvents.isEmpty) {
    //   return [];
    // }
    // //
    // List<Scalar> scalarList = __getListenerScalarsByAffectedItemTypes(
    //   eventShelf: eventBlock.shelf,
    //   affectedItemTypeEvents: itemTypeEvents,
    // );
    // return scalarList
    //     .where((scalar) => !identical(scalar.shelf, eventBlock.shelf))
    //     .toList();
    throw UnimplementedError();
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
    // Set<Type> itemTypeEvents = eventBlock.getDeclaredBroadcastDataTypes();
    // if (itemTypeEvents.isEmpty) {
    //   return [];
    // }
    // //
    // List<Block> blockList = __getListenerBlocksByAffectedItemTypes(
    //   eventShelf: eventBlock.shelf,
    //   affectedItemTypeEvents: itemTypeEvents,
    // );
    // return blockList
    //     .where((block) => !identical(block.shelf, eventBlock.shelf))
    //     .toList();
    throw UnimplementedError();
  }

  // ***************************************************************************
  // ***************************************************************************

  // Callable.
  // List<Block> __getListenerBlocksByAffectedItemTypes({
  //   required Shelf eventShelf,
  //   required Set<Type> affectedItemTypeEvents,
  // }) {
  //   // FullName, Block
  //   Map<String, Block> foundMap = {};
  //
  //   for (String shelfName in storage.activeShelfNames) {
  //     Shelf? shelf = storage.findShelfByName(shelfName);
  //     if (shelf == null) {
  //       continue;
  //     }
  //     for (Block blockToCheck in shelf.blocks) {
  //       for (Type affectedType in affectedItemTypeEvents) {
  //         // FIXED TODO: Compared directly with Type lists
  //         if (_contains(
  //             blockToCheck.getDeclaredReactionDataTypes(), affectedType)) {
  //           foundMap[blockToCheck._shortPathName] = blockToCheck;
  //           break;
  //         }
  //       }
  //     }
  //   }
  //   return foundMap.values.toList();
  // }

  // ***************************************************************************
  // ***************************************************************************

  List<Scalar> __getListenerScalarsByAffectedItemTypes({
    required Shelf eventShelf,
    required Set<Type> affectedItemTypeEvents,
  }) {
    // FullName, Scalar
    Map<String, Scalar> foundMap = {};

    for (String shelfName in storage.activeShelfNames) {
      Shelf? shelf = storage.findShelfByName(shelfName);
      if (shelf == null || identical(shelf, eventShelf)) {
        continue;
      }
      for (Scalar scalar in shelf.scalars) {
        // FIXED TODO: Compared directly with Type lists
        Set<Type> listenerTypeEvents = scalar.getDeclaredReactionDataTypes();
        for (Type affectedType in affectedItemTypeEvents) {
          if (_contains(listenerTypeEvents, affectedType)) {
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
    // // FullName, Block
    // Map<String, Block> foundMap = {};
    //
    // for (Shelf shelf in storage.getAllShelves()) {
    //   List<Block> allBlocks = shelf.blocks;
    //   for (Block blk in allBlocks) {
    //     if (blk.getDeclaredReactionDataTypes().isEmpty) {
    //       continue;
    //     }
    //     // FIXED TODO: Evaluated directly via core structural types exposed
    //     final Set<Type> listenToDataTypes =
    //         listenerBlock.getDeclaredReactionDataTypes();
    //     final Type itemType = blk.getItemType();
    //     final Type itemDetailType = blk.getItemDetailType();
    //
    //     if (_contains(listenToDataTypes, itemType) ||
    //         _contains(listenToDataTypes, itemDetailType)) {
    //       foundMap[blk._shortPathName] = blk;
    //     }
    //   }
    // }
    // return foundMap.values.toList();
    throw UnimplementedError();
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
    // // FullName, Block
    // Map<String, Block> foundMap = {};
    //
    // for (Shelf shelf in storage.getAllShelves()) {
    //   for (Block blk in shelf.blocks) {
    //     if (blk.getDeclaredReactionDataTypes().isEmpty) {
    //       continue;
    //     }
    //     Set<Type> listenerTypes = listenerScalar.getDeclaredReactionDataTypes();
    //     if (listenerTypes.isEmpty) {
    //       continue;
    //     }
    //     final Type itemType = blk.getItemType();
    //     final Type itemDetailType = blk.getItemDetailType();
    //
    //     if (_contains(listenerTypes, itemType) ||
    //         _contains(listenerTypes, itemDetailType)) {
    //       foundMap[blk._shortPathName] = blk;
    //     }
    //   }
    // }
    // return foundMap.values.toList();
    throw UnimplementedError();
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
          classDefinition: eventBlock.debug.classDefinition,
          classParameterDefinition: eventBlock.debug.classParametersDefinition,
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
            classDefinition: listenerBlock.debug.classDefinition,
            classParameterDefinition:
                listenerBlock.debug.classParametersDefinition,
          ),
        );
      }
      for (Scalar listenerScalar in listenerScalars) {
        foundShelfBlockTypes.add(
          ShelfBlockScalarType.scalar(
            shelfType: listenerScalar.shelf.runtimeType,
            scalarType: listenerScalar.runtimeType,
            classDefinition: listenerScalar.debug.classDefinition,
            classParameterDefinition:
                listenerScalar.debug.classParametersDefinition,
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

  /// Validates directly against raw Type objects instead of old Event wrappers.
  bool _contains(Set<Type> listenTypeEvents, Type targetType) {
    for (Type t in listenTypeEvents) {
      if (t == targetType) {
        return true;
      }
    }
    return false;
  }
}
