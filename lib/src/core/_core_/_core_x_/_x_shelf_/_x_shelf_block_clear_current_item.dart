part of '../../core.dart';

class _XShelfBlockClearCurrentItem extends XShelf {
  _XShelfBlockClearCurrentItem({required Block block})
      : super(
          xShelfType: XShelfType.blockCurrItemClearance,
          shelf: block.shelf,
        ) {
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }
}
