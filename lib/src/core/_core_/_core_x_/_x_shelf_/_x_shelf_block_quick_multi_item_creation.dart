part of '../../core.dart';

class _XShelfBlockMultiItemCreationBackendAction extends XShelf {
  _XShelfBlockMultiItemCreationBackendAction({required Block block})
      : super(
          xShelfType: XShelfType.blockMultiItemCreationBackendAction,
          shelf: block.shelf,
        ) {
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }
}
