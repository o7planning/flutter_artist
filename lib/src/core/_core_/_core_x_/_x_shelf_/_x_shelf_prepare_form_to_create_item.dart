part of '../../core.dart';

class _XShelfPrepareFormToCreateItem extends XShelf {
  _XShelfPrepareFormToCreateItem({required Block block})
      : super(
          xShelfType: XShelfType.blockPrepareFormToCreateItem,
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
