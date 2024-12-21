part of '../flutter_artist.dart';

class _FlutterArtistChangeManager {
  final Map<String, Frame> _registedFrameMap = {};

  // ===========================================================================
  // ===========================================================================

  void _registerFrame(String frameName, Frame frame) {
    _registedFrameMap[frameName] = frame;
  }

  // ===========================================================================
  // ===========================================================================

  Map<SourceOfChange, List<Block>> _getNotifierAndListenerMap() {
    Map<SourceOfChange, List<Block>> returnMap = {};
    for (Frame frame in _registedFrameMap.values) {
      for (Block block in frame.rootBlocks) {
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
  List<FrameBlockType> getChangeListeners({required Block sourceBlock}) {
    SourceOfChange source = _blockToSourceOfChange(sourceBlock);

    List<Block> listenerBlocks = _getNotifierAndListenerMap()[source] ?? [];
    return listenerBlocks
        .map(
          (b) => FrameBlockType(
            frameType: b.frame.runtimeType,
            blockType: b.runtimeType,
          ),
        )
        .toList();
  }

  SourceOfChange _blockToSourceOfChange(Block sourceBlock) {
    Type frameType = sourceBlock.frame.runtimeType;
    Type blockType = sourceBlock.runtimeType;
    SourceOfChange source = SourceOfChange(
      frameType: frameType,
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
      queryBlocks.first.frame._queryBlocks(
        queryType: QueryType.forceQuery,
        blocks: queryBlocks,
      );
    }
  }
}
