part of '../../core.dart';

class _XShelfBlockClearItems extends XShelf {
  _XShelfBlockClearItems({
    required Block block,
  }) : super(
          xShelfType: XShelfType.blockClearItems,
          shelf: block.shelf,
        ) {
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }
}
