part of '../../core.dart';

class _XShelfBlockFormModelPatchFormFields extends XShelf {
  _XShelfBlockFormModelPatchFormFields({
    required BlockFormModel formModel,
  }) : super(
          xShelfType: XShelfType.formModelEnterFields,
          shelf: formModel.block.shelf,
        ) {
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[formModel.block.name]!;
  }
}
