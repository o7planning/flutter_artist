part of '../../core.dart';

class _XShelfBlockItemDeletion extends XShelf {
  _XShelfBlockItemDeletion({required Block block})
      : super(
          xShelfType: XShelfType.blockItemDeletion,
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
