part of '../../core.dart';

class _XShelfBlockQuickMuliItemsCreation extends XShelf {
  _XShelfBlockQuickMuliItemsCreation({required Block block})
      : super(
          xShelfType: XShelfType.blockQuickMultiItemsCreation,
          shelf: block.shelf,
          resetReactionTypeToExternal: true,
        ) {
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }
}
