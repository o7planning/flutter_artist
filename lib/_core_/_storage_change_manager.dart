part of '../flutter_artist.dart';

class _StorageChangeManager {
  final Map<String, Shelf> _registedShelfMap = {};

  // ===========================================================================
  // ===========================================================================

  void _registerShelf(String shelfName, Shelf shelf) {
    _registedShelfMap[shelfName] = shelf;
  }

  // ===========================================================================
  // ===========================================================================

  Map<SourceOfChange, List<Block>> _getNotifierAndListenerMap() {
    Map<SourceOfChange, List<Block>> returnMap = {};
    for (Shelf shelf in _registedShelfMap.values) {
      for (Block block in shelf.rootBlocks) {
        __registerListenerBlockCascade(block, returnMap);
      }
    }
    return returnMap;
  }

  void __registerListenerBlockCascade(
      Block listenerBlock, Map<SourceOfChange, List<Block>> returnMap) {
    List<SourceOfChange>? sources = listenerBlock.listenForChangesFrom;
    for (SourceOfChange source in sources ?? []) {
      List<Block>? list = returnMap[source];
      if (list == null) {
        list = [];
        returnMap[source] = list;
      }
      list.add(listenerBlock);
    }
    for (Block childBlock in listenerBlock._childBlocks) {
      __registerListenerBlockCascade(childBlock, returnMap);
    }
  }

  // ===========================================================================
  // ===========================================================================

  @deprecated
  List<ShelfBlockType> getChangeListeners({required Block sourceBlock}) {
    SourceOfChange source = _blockToSourceOfChange(sourceBlock);

    List<Block> listenerBlocks = _getNotifierAndListenerMap()[source] ?? [];
    return listenerBlocks
        .map(
          (b) => ShelfBlockType(
            shelfType: b.shelf.runtimeType,
            blockType: b.runtimeType,
          ),
        )
        .toList();
  }

  SourceOfChange _blockToSourceOfChange(Block sourceBlock) {
    Type shelfType = sourceBlock.shelf.runtimeType;
    Type blockType = sourceBlock.runtimeType;
    SourceOfChange source = SourceOfChange(
      shelfType: shelfType,
      blockType: blockType,
    );
    return source;
  }

  void _notifyChange(Block sourceBlock, String? itemIdString) {
    SourceOfChange source = _blockToSourceOfChange(sourceBlock);
    print("~~~~~~~~~> SourceOfChange: ${source}");
    List<Block> listenerBlocks = _getNotifierAndListenerMap()[source] ?? [];
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
}
