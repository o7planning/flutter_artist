part of '../../core.dart';

class _XShelfBlockQuickItemUpdate extends XShelf {
  _XShelfBlockQuickItemUpdate({required Block block})
      : super(
    shelf: block.shelf,
    xShelfType: XShelfType.blockQuickItemUpdate,
  ) {
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }
}
