part of '../../core.dart';

class _XShelfBlockBulkItemsCreationAction extends XShelf {
  _XShelfBlockBulkItemsCreationAction({required Block block})
      : super(
          xShelfType: XShelfType.blockBulkItemsCreation,
          shelf: block.shelf,
        ) {
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }
}
