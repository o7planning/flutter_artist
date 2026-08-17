part of '../../core.dart';

class _XShelfFormModelPatchFormFields extends XShelf {
  _XShelfFormModelPatchFormFields({required FormModel formModel})
      : super(
          xShelfType: XShelfType.formModelEnterFields,
          shelf: formModel.block.shelf,
        ) {
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[formModel.block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }
}
