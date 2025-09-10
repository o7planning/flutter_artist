part of '../../core.dart';

class _XShelfBlockQuickMuliItemsCreation extends XShelf {
  _XShelfBlockQuickMuliItemsCreation({required Block block})
      : super._(
            xShelfType: XShelfType.blockQuickMultiItemsCreation,
            shelf: block.shelf) {
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }
}
