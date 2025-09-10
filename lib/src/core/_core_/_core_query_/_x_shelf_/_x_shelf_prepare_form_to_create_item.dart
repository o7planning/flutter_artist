part of '../../core.dart';

class _XShelfPrepareFormToCreateItem extends XShelf {
  _XShelfPrepareFormToCreateItem({required Block block})
      : super._(
            xShelfType: XShelfType.blockPrepareFormToCreateItem,
            shelf: block.shelf) {
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }
}
