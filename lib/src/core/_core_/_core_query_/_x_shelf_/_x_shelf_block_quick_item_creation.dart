part of '../../core.dart';

class _XShelfBlockQuickItemCreation extends XShelf {
  _XShelfBlockQuickItemCreation({required Block block})
      : super._(
          xShelfType: XShelfType.blockQuickItemCreation,
          shelf: block.shelf,
        ) {
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }
}
