part of '../../core.dart';

class _XShelfBlockQuickMultiItemCreationAction extends XShelf {
  _XShelfBlockQuickMultiItemCreationAction({required Block block})
      : super(
          xShelfType: XShelfType.blockQuickMultiItemCreation,
          shelf: block.shelf,
        ) {
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }
}
