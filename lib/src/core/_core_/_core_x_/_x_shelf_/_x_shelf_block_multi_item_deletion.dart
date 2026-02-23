part of '../../core.dart';

class _XShelfBlockMultiItemDeletion extends XShelf {
  _XShelfBlockMultiItemDeletion({required Block block})
      : super(
          xShelfType: XShelfType.blockMultiItemDeletion,
          shelf: block.shelf,
        ) {
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }
}
