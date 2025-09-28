part of '../../core.dart';

class _XShelfBlockCurrItemSelection extends XShelf {
  _XShelfBlockCurrItemSelection({required Block block})
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
