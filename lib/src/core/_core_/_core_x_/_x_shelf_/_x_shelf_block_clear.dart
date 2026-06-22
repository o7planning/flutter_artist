part of '../../core.dart';

class _XShelfBlockClear extends XShelf {
  _XShelfBlockClear({required Block block})
      : super(
          xShelfType: XShelfType.blockClear,
          shelf: block.shelf,
        ) {
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }
}
