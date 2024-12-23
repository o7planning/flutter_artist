part of '../flutter_artist.dart';

_GraphItem _toRootDebugGraphItem(Shelf shelf) {
  _GraphItem rootItem = _GraphItem.shelf(shelf);
  for (Block rootBlock in shelf.rootBlocks) {
    _GraphItem item = _toDebugGraphItemCascade(rootBlock);
    rootItem.children.add(item);
  }
  return rootItem;
}

_GraphItem _toDebugGraphItemCascade(Block block) {
  _GraphItem item = _GraphItem.block(block);
  for (Block childBlock in block.childBlocks) {
    _GraphItem childItem = _toDebugGraphItemCascade(childBlock);
    item.children.add(childItem);
  }
  return item;
}
