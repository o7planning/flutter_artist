part of '../../core.dart';

class _XShelfFormViewChange extends XShelf {
  _XShelfFormViewChange({required FormModel formModel})
      : super(
    xShelfType: XShelfType.formViewChange,
    shelf: formModel.shelf,
  ) {
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[formModel.block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }
}
