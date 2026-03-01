part of '../../core.dart';

class _XShelfBlockClearance extends XShelf {
  _XShelfBlockClearance({required Block block})
      : super(
    xShelfType: XShelfType.blockClearance,
    shelf: block.shelf,
  ) {
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }
}
