part of '../../core.dart';

class _XShelfFormModelEnterFields extends XShelf {
  _XShelfFormModelEnterFields({required FormModel formModel})
      : super._(
            xShelfType: XShelfType.formModelEnterFields,
            shelf: formModel.block.shelf) {
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[formModel.block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }
}
