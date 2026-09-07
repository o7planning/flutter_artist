part of '../core.dart';

class _EventHelper {
  final _Storage storage;

  _EventHelper(this.storage);

  // ***************************************************************************
  // 1. GET LISTENER SCALARS BY EVENT BLOCK
  // ***************************************************************************

  List<Scalar> __getListenerScalarsByBlock({
    required Block eventBlock,
  }) {
    // Resolve all broadcast types including ProjectionFamily members
    Set<Type> itemTypeEvents = eventBlock.getResolvedBroadcastDataTypes();
    if (itemTypeEvents.isEmpty) {
      return [];
    }

    List<Scalar> scalarList = __getListenerScalarsByAffectedItemTypes(
      eventShelf: eventBlock.shelf,
      affectedItemTypeEvents: itemTypeEvents,
    );

    return scalarList
        .where((scalar) => !identical(scalar.shelf, eventBlock.shelf))
        .toList();
  }

  // ***************************************************************************
  // 2. GET LISTENER BLOCKS BY EVENT SHELF
  // ***************************************************************************

  List<Block> _getListenerBlocksByShelf({
    required Shelf eventShelf,
  }) {
    Map<String, Block> foundMap = {};

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
  // 3. GET LISTENER BLOCKS BY EVENT BLOCK
  // ***************************************************************************

  List<Block> __getListenerBlocksByBlock({
    required Block eventBlock,
  }) {
    // Resolve all broadcast types including ProjectionFamily members
    Set<Type> itemTypeEvents = eventBlock.getResolvedBroadcastDataTypes();
    if (itemTypeEvents.isEmpty) {
      return [];
    }

    List<Block> blockList = __getListenerBlocksByAffectedItemTypes(
      eventShelf: eventBlock.shelf,
      affectedItemTypeEvents: itemTypeEvents,
    );

    return blockList
        .where((block) => !identical(block.shelf, eventBlock.shelf))
        .toList();
  }

  // ***************************************************************************
  // 4. FIND BLOCKS LISTENING TO AFFECTED TYPES (RESOLVED AWARE)
  // ***************************************************************************

  List<Block> __getListenerBlocksByAffectedItemTypes({
    required Shelf eventShelf,
    required Set<Type> affectedItemTypeEvents,
  }) {
    Map<String, Block> foundMap = {};

    for (String shelfName in storage.activeShelfNames) {
      Shelf? shelf = storage.findShelfByName(shelfName);
      if (shelf == null) {
        continue;
      }
      for (Block blockToCheck in shelf.blocks) {
        // Resolve all reaction data types for the listener block
        final Set<Type> listenerResolvedTypes =
        blockToCheck.getResolvedReactionDataTypes(target: null);

        // Check if any affected type matches the resolved listener reaction types
        if (affectedItemTypeEvents
            .any((type) => listenerResolvedTypes.contains(type))) {
          foundMap[blockToCheck._shortPathName] = blockToCheck;
        }
      }
    }
    return foundMap.values.toList();
  }

  // ***************************************************************************
  // 5. FIND SCALARS LISTENING TO AFFECTED TYPES (RESOLVED AWARE)
  // ***************************************************************************

  List<Scalar> __getListenerScalarsByAffectedItemTypes({
    required Shelf eventShelf,
    required Set<Type> affectedItemTypeEvents,
  }) {
    Map<String, Scalar> foundMap = {};

    for (String shelfName in storage.activeShelfNames) {
      Shelf? shelf = storage.findShelfByName(shelfName);
      if (shelf == null || identical(shelf, eventShelf)) {
        continue;
      }
      for (Scalar scalar in shelf.scalars) {
        // Resolve all reaction data types for the listener scalar
        Set<Type> listenerResolvedTypes = scalar.getResolvedReactionDataTypes();

        if (affectedItemTypeEvents
            .any((type) => listenerResolvedTypes.contains(type))) {
          foundMap[scalar._shortPathName] = scalar;
        }
      }
    }
    return foundMap.values.toList();
  }

  // ***************************************************************************
  // 6. FIND EVENT BLOCKS THAT CAN TRIGGER THIS LISTENER BLOCK
  // ***************************************************************************

  List<Block> _getEventBlocksByBlock({
    required Block listenerBlock,
  }) {
    Map<String, Block> foundMap = {};
    final Set<Type> listenerResolvedTypes =
    listenerBlock.getResolvedReactionDataTypes(target: null);

    if (listenerResolvedTypes.isEmpty) {
      return [];
    }

    for (Shelf shelf in storage.getAllShelves()) {
      for (Block blk in shelf.blocks) {
        final Set<Type> broadcastResolvedTypes =
        blk.getResolvedBroadcastDataTypes();

        if (broadcastResolvedTypes.isEmpty) {
          continue;
        }

        // If there is any intersection between what blk broadcasts and what listenerBlock listens to
        if (broadcastResolvedTypes
            .any((type) => listenerResolvedTypes.contains(type))) {
          foundMap[blk._shortPathName] = blk;
        }
      }
    }
    return foundMap.values.toList();
  }

  // ***************************************************************************
  // 7. FIND EVENT BLOCKS THAT CAN TRIGGER THIS LISTENER SHELF
  // ***************************************************************************

  List<Block> _getEventBlocksByShelf({required Shelf listenerShelf}) {
    Map<String, Block> foundMap = {};

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
  // 8. GET LISTENER SCALARS BY EVENT SHELF
  // ***************************************************************************

  List<Scalar> _getListenerScalarsByShelf({
    required Shelf eventShelf,
  }) {
    Map<String, Scalar> foundMap = {};

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
  // 9. FIND EVENT BLOCKS THAT CAN TRIGGER THIS LISTENER SCALAR
  // ***************************************************************************

  List<Block> _getEventBlocksByScalar({
    required Scalar listenerScalar,
  }) {
    Map<String, Block> foundMap = {};
    Set<Type> listenerResolvedTypes =
    listenerScalar.getResolvedReactionDataTypes();

    if (listenerResolvedTypes.isEmpty) {
      return [];
    }

    for (Shelf shelf in storage.getAllShelves()) {
      for (Block blk in shelf.blocks) {
        final Set<Type> broadcastResolvedTypes =
        blk.getResolvedBroadcastDataTypes();

        if (broadcastResolvedTypes.isEmpty) {
          continue;
        }

        // If blk broadcasts any data type matching listenerScalar's resolved reactions
        if (broadcastResolvedTypes
            .any((type) => listenerResolvedTypes.contains(type))) {
          foundMap[blk._shortPathName] = blk;
        }
      }
    }
    return foundMap.values.toList();
  }

  // ***************************************************************************
  // 10. PUBLIC MAPPINGS & QUERIES
  // ***************************************************************************

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

  Map<String, Shelf> _getListenerShelves() {
    Map<String, Shelf> foundShelfMap = {};

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

  Map<String, Shelf> _getEventShelves() {
    Map<String, Shelf> foundEventShelfMap = {};

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
}
