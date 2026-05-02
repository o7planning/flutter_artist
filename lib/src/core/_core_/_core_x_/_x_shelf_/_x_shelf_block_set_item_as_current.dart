part of '../../core.dart';

class _XShelfBlockSetItemAsCurrent extends XShelf {
  _XShelfBlockSetItemAsCurrent({required Block block})
      : super(
          xShelfType: XShelfType.blockCurrItemSelection,
          shelf: block.shelf,
        ) {
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }
}
